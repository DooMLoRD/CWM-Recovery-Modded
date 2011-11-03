# Audio jack configuration
dev=/sys/devices/platform/simple_remote.0
echo 0,501,1600 > $dev/accessory_min_vals  # default = 0,200,1600
echo 500,1600  > $dev/accessory_max_vals  # default = 200,1600
echo 0,100,280,500 > $dev/button_min_vals  # default = 0,100,280,500
echo 99,199,399,750  > $dev/button_max_vals  # default = 99,199,399,750
echo 512   > $dev/btn_trig_period_freq  # Button Period Freq(Hz) default = 512
echo 16  > $dev/btn_trig_period_time  # Button Period Time(cycle) default = 16
echo 512   > $dev/btn_trig_hyst_freq    # Button Hysteresis Freq(Hz) default = 512
echo 1  > $dev/btn_trig_hyst_time   # Button Hysteresis Time(Cycle) default = 16
echo 480 > $dev/btn_trig_level  # default = 500

