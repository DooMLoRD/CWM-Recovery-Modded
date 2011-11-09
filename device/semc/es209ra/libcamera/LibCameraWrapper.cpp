/*
 * Copyright (C) 2011 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "LibCameraWrapper"

#include <cmath>
#include <dlfcn.h>
#include <fcntl.h>
#include <linux/videodev2.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <camera/Camera.h>
#include "LibCameraWrapper.h"

namespace android {

extern "C" int HAL_getNumberOfCameras()
{
    return 1;
}

extern "C" void HAL_getCameraInfo(int cameraId, struct CameraInfo* cameraInfo)
{
    cameraInfo->facing = CAMERA_FACING_BACK;
    cameraInfo->orientation = 90;
}

extern "C" sp<CameraHardwareInterface> HAL_openCameraHardware(int cameraId)
{
    LOGV("openCameraHardware: call createInstance");
    return LibCameraWrapper::createInstance(cameraId);
}

wp<CameraHardwareInterface> LibCameraWrapper::singleton;

static bool
deviceCardMatches(const char *device, const char *matchCard)
{
    struct v4l2_capability caps;
    int fd = ::open(device, O_RDWR);
    bool ret;

    if (fd < 0) {
        return false;
    }

    if (::ioctl(fd, VIDIOC_QUERYCAP, &caps) < 0) {
        ret = false;
    } else {
        const char *card = (const char *) caps.card;

        LOGD("device %s card is %s\n", device, card);
        ret = strstr(card, matchCard) != NULL;
    }

    ::close(fd);

    return ret;
}

static sp<CameraHardwareInterface>
openLibInterface(const char *libName, const char *funcName)
{
    sp<CameraHardwareInterface> interface;
    void *libHandle = ::dlopen(libName, RTLD_NOW);

    if (libHandle != NULL) {
        typedef sp<CameraHardwareInterface> (*OpenCamFunc)();
        OpenCamFunc func = (OpenCamFunc) ::dlsym(libHandle, funcName);
        if (func != NULL) {
            interface = func();
        } else {
            LOGE("Could not find library entry point!");
        }
    } else {
        LOGE("dlopen() error: %s\n", dlerror());
    }

    return interface;
}

static void
setSocTorchMode(bool enable)
{
    int fd = ::open("/sys/class/leds/lv5219lg:fled/brightness", O_WRONLY);
    if (fd >= 0) {
        const char *value = enable ? "200" : "0";
        write(fd, value, sizeof(value));
        close(fd);
    }
}

sp<CameraHardwareInterface> LibCameraWrapper::createInstance(int cameraId)
{
    LOGV("%s :", __func__);
    if (singleton != NULL) {
        sp<CameraHardwareInterface> hardware = singleton.promote();
        if (hardware != NULL) {
            return hardware;
        }
    }

    CameraType type = CAM_SOC;
    sp<CameraHardwareInterface> libInterface;
    sp<CameraHardwareInterface> hardware;

    libInterface = openLibInterface("libcamerasemc.so", "_ZN7android18SemcCameraHardware14createInstanceEv");

    if (libInterface != NULL) {
        hardware = new LibCameraWrapper(libInterface, type);
        singleton = hardware;
    } else {
        LOGE("Could not open hardware interface");
    }

    return hardware;
}

LibCameraWrapper::LibCameraWrapper(sp<CameraHardwareInterface>& libInterface, CameraType type) :
    mLibInterface(libInterface),
    mCameraType(type),
    mVideoMode(false),
    mNotifyCb(NULL),
    mDataCb(NULL),
    mDataCbTimestamp(NULL),
    mCbUserData(NULL)
{
}

LibCameraWrapper::~LibCameraWrapper()
{
    if (mLastFlashMode == CameraParameters::FLASH_MODE_ON ||
        mLastFlashMode == CameraParameters::FLASH_MODE_TORCH)
    {
        setSocTorchMode(false);
    }
}

sp<IMemoryHeap>
LibCameraWrapper::getPreviewHeap() const
{
    return mLibInterface->getPreviewHeap();
}

sp<IMemoryHeap>
LibCameraWrapper::getRawHeap() const
{
    return mLibInterface->getRawHeap();
}

void
LibCameraWrapper::setCallbacks(notify_callback notify_cb,
                                  data_callback data_cb,
                                  data_callback_timestamp data_cb_timestamp,
                                  void* user)
{
    mNotifyCb = notify_cb;
    mDataCb = data_cb;
    mDataCbTimestamp = data_cb_timestamp;
    mCbUserData = user;

    if (mNotifyCb != NULL) {
        notify_cb = &LibCameraWrapper::notifyCb;
    }
    if (mDataCb != NULL) {
        data_cb = &LibCameraWrapper::dataCb;
    }
    if (mDataCbTimestamp != NULL) {
        data_cb_timestamp = &LibCameraWrapper::dataCbTimestamp;
    }

    mLibInterface->setCallbacks(notify_cb, data_cb, data_cb_timestamp, this);
}

void
LibCameraWrapper::notifyCb(int32_t msgType, int32_t ext1, int32_t ext2, void* user)
{
    LibCameraWrapper *_this = (LibCameraWrapper *) user;
    user = _this->mCbUserData;

    _this->mNotifyCb(msgType, ext1, ext2, user);
}

void
LibCameraWrapper::dataCb(int32_t msgType, const sp<IMemory>& dataPtr, void* user)
{
    LibCameraWrapper *_this = (LibCameraWrapper *) user;
    user = _this->mCbUserData;

    _this->mDataCb(msgType, dataPtr, user);
}

void
LibCameraWrapper::dataCbTimestamp(nsecs_t timestamp, int32_t msgType,
                                     const sp<IMemory>& dataPtr, void* user)
{
    LibCameraWrapper *_this = (LibCameraWrapper *) user;
    user = _this->mCbUserData;

    _this->mDataCbTimestamp(timestamp, msgType, dataPtr, user);
}



void
LibCameraWrapper::enableMsgType(int32_t msgType)
{
    mLibInterface->enableMsgType(msgType);
}

void
LibCameraWrapper::disableMsgType(int32_t msgType)
{
    mLibInterface->disableMsgType(msgType);
}

bool
LibCameraWrapper::msgTypeEnabled(int32_t msgType)
{
    return mLibInterface->msgTypeEnabled(msgType);
}

status_t
LibCameraWrapper::getBufferInfo(sp<IMemory>& Frame, size_t *alignedSize) {
LOGV("%s :", _func_);
return mLibInterface->getBufferInfo(Frame, alignedSize);
}

status_t
LibCameraWrapper::startPreview()
{
    return mLibInterface->startPreview();
}

bool
LibCameraWrapper::useOverlay()
{
    return mLibInterface->useOverlay();
}

status_t
LibCameraWrapper::setOverlay(const sp<Overlay> &overlay)
{
    return mLibInterface->setOverlay(overlay);
}

void
LibCameraWrapper::stopPreview()
{
    mLibInterface->stopPreview();
}

bool
LibCameraWrapper::previewEnabled()
{
    return mLibInterface->previewEnabled();
}

status_t
LibCameraWrapper::startRecording()
{
    return mLibInterface->startRecording();
}

void
LibCameraWrapper::stopRecording()
{
    mLibInterface->stopRecording();
}

bool
LibCameraWrapper::recordingEnabled()
{
    return mLibInterface->recordingEnabled();
}

void
LibCameraWrapper::releaseRecordingFrame(const sp<IMemory>& mem)
{
    return mLibInterface->releaseRecordingFrame(mem);
}

status_t
LibCameraWrapper::autoFocus()
{
    return mLibInterface->autoFocus();
}

status_t
LibCameraWrapper::cancelAutoFocus()
{
    return mLibInterface->cancelAutoFocus();
}

status_t
LibCameraWrapper::takePicture()
{
    return mLibInterface->takePicture();
}

status_t
LibCameraWrapper::cancelPicture()
{
    return mLibInterface->cancelPicture();
}

status_t
LibCameraWrapper::setParameters(const CameraParameters& params)
{
    CameraParameters pars(params.flatten());

    const char *flashMode = pars.get(CameraParameters::KEY_FLASH_MODE);
        if (flashMode != NULL) {
            if (mLastFlashMode != flashMode) {
                bool shouldBeOn = strcmp(flashMode, CameraParameters::FLASH_MODE_TORCH) == 0 ||
                                  strcmp(flashMode, CameraParameters::FLASH_MODE_ON) == 0;
                setSocTorchMode(shouldBeOn);
            }
            mLastFlashMode = flashMode;
    }

    return mLibInterface->setParameters(pars);
}

CameraParameters
LibCameraWrapper::getParameters() const
{
    CameraParameters ret = mLibInterface->getParameters();

        // We support facedetect as well
        ret.set("focus-mode-values", "auto");

        // This is for detecting if we're in camcorder mode or not
        ret.set("cam-mode", mVideoMode ? "1" : "0");

        ret.set("flash-mode-values", "off,on");

        // FFC: We need more preview and picture size to support GTalk
        ret.set("preview-size-values", "320x240,640x480,1280x720");

    ret.set(CameraParameters::KEY_MAX_ZOOM, "0");

    return ret;
}

status_t
LibCameraWrapper::sendCommand(int32_t cmd, int32_t arg1, int32_t arg2)
{
    return mLibInterface->sendCommand(cmd, arg1, arg2);
}

void
LibCameraWrapper::release()
{
    mLibInterface->release();
}

status_t
LibCameraWrapper::dump(int fd, const Vector<String16>& args) const
{
    return mLibInterface->dump(fd, args);
}

}; //namespace android
