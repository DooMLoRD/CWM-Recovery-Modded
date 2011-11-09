# lv5219lg LMU configuration
echo 1 > /sys/class/leds/lv5219lg:mled/als_enable
echo 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 > /sys/class/leds/lv5219lg:mled/als_config
echo 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 > /sys/class/leds/lv5219lg:mled/als_config
echo 2 7 7 7 7 7 7 7 7 7 15 15 15 15 15 15 15 > /sys/class/leds/lv5219lg:mled/als_config
echo 3 7 7 11 11 11 15 15 15 15 19 19 19 19 23 23 23 > /sys/class/leds/lv5219lg:mled/als_config
echo 4 11 11 11 15 15 19 19 19 19 23 23 23 23 27 27 31 > /sys/class/leds/lv5219lg:mled/als_config
echo 5 11 11 15 15 15 19 23 23 23 31 31 35 35 43 43 51 > /sys/class/leds/lv5219lg:mled/als_config
echo 6 11 15 15 15 19 19 23 23 23 31 45 45 51 51 67 67 > /sys/class/leds/lv5219lg:mled/als_config
echo 7 15 19 19 19 23 23 31 31 43 43 51 51 67 67 83 83 > /sys/class/leds/lv5219lg:mled/als_config
echo 8 19 19 23 23 31 31 43 43 51 51 67 67 83 83 95 103 > /sys/class/leds/lv5219lg:mled/als_config
echo 9 27 35 35 43 43 51 51 59 59 67 75 75 91 91 99 103 > /sys/class/leds/lv5219lg:mled/als_config
echo 10 43 43 51 51 59 59 67 67 75 75 83 83 95 95 103 107 > /sys/class/leds/lv5219lg:mled/als_config
echo 11 55 59 59 67 67 75 75 83 83 91 91 99 99 103 103 111 > /sys/class/leds/lv5219lg:mled/als_config
echo 12 67 67 75 75 83 83 91 91 95 95 99 103 103 107 107 115 > /sys/class/leds/lv5219lg:mled/als_config
echo 13 79 83 83 87 87 95 95 99 99 103 103 107 107 111 111 115 > /sys/class/leds/lv5219lg:mled/als_config
echo 14 99 99 107 107 107 107 111 111 111 111 115 115 115 115 119 119 > /sys/class/leds/lv5219lg:mled/als_config
echo 15 115 115 115 115 115 115 115 115 115 123 123 123 123 123 123 123 > /sys/class/leds/lv5219lg:mled/als_config
echo 16 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 > /sys/class/leds/lv5219lg:mled/als_config

mount -o rw,remount -t yaffs2 /dev/block/mtdblock2 /system
chmod u+s /system/bin/charger
mount -o ro,remount -t yaffs2 /dev/block/mtdblock2 /system

#Z FPS Uncap
mount -t debugfs debugfs /sys/kernel/debug
echo '0' > /sys/kernel/debug/msm_fb/0/vsync_enable
umount /sys/kernel/debug