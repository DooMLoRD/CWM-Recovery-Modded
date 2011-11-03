# Audio jack configuration
dev=/sys/devices/platform/simple_remote.0
echo 0,201,1600 > $dev/accessory_min_vals  # default = 0,200,1600
echo 200,1599  > $dev/accessory_max_vals  # default = 200,1600
echo 0,100,280,500,700 > $dev/button_min_vals  # default = 0,100,300,600,700
echo 99,199,399,699,5000  > $dev/button_max_vals  # default = 99,199,399,699,5000
echo 512   > $dev/btn_trig_period_freq  # Button Period Freq(Hz) default = 512
echo 16  > $dev/btn_trig_period_time  # Button Period Time(cycle) default = 16
echo 512   > $dev/btn_trig_hyst_freq    # Button Hysteresis Freq(Hz) default = 512
echo 16  > $dev/btn_trig_hyst_time   # Button Hysteresis Time(Cycle) default = 16
echo 500 > $dev/btn_trig_level  # default = 500

# Proximity sensor configuration
dev=/sys/bus/i2c/devices/0-0054
hwid=`cat /sys/class/hwid/hwid`
case $hwid in
 0x0a)
  val_cycle=2
  val_nburst=7
  val_freq=3
  val_threshold=15
  val_filter=0
  ;;
 *)
  val_cycle=2
  val_nburst=8
  val_freq=2
  val_threshold=15
  val_filter=0
  ;;
esac

nv_param_loader 60240 prox_cal
val_calibrated=$?
case $val_calibrated in
 1)
  nv_param_loader 60240 threshold
  val_threshold=$?
  nv_param_loader 60240 rfilter
  val_filter=$?
  ;;
esac

echo $val_cycle > $dev/cycle    # Duration Cycle. Valid range is 0 - 3.
echo $val_nburst > $dev/nburst  # Number of pulses in burst. Valid range is 0 - 15.
echo $val_freq > $dev/freq      # Burst frequency. Valid range is 0 - 3.
echo $val_threshold > $dev/threshold # sensor threshold. Valid range is 0 - 15 (0.12V - 0.87V)
echo $val_filter > $dev/filter  # RFilter. Valid range is 0 - 3.

# LMU AS3676 Configuration
dev=/sys/devices/i2c-0/0-0040/leds
echo 1,65,255,24,24,5,128 > $dev/lcd-backlight/als/curve  # ALS curve for group1
echo 2,0,0,0 > $dev/lcd-backlight/als/params  #[gain],[filter_up],[filter_down],[offset]
echo 1 > $dev/lcd-backlight/als/enable  #Sensor on/off. 1 = on, reg 90h
echo 450 > $dev/button-backlight/max_current

# TI BQ275xx firmware loader
bq275xx_fwloader
