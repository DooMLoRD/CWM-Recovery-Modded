char const*const RED_LED_FILE 			= "/sys/class/leds/red/brightness";
char const*const GREEN_LED_FILE 		= "/sys/class/leds/green/brightness";
char const*const BLUE_LED_FILE 			= "/sys/class/leds/blue/brightness";

char const*const RED_LED_FILE_TRIGGER	  = "/sys/class/leds/red/trigger";
char const*const GREEN_LED_FILE_TRIGGER	= "/sys/class/leds/green/trigger";
char const*const BLUE_LED_FILE_TRIGGER	= "/sys/class/leds/blue/trigger";

char const*const BUTTON_BACKLIGHT_FILE[] = {
  "/sys/class/leds/button-backlight/brightness",
  "/sys/class/leds/button-backlight-rgb1/brightness",
  "/sys/class/leds/button-backlight-rgb2/brightness",
  "/sys/class/leds/keyboard-backlight/brightness"
};

char const*const LCD_BACKLIGHT_FILE	= "/sys/class/leds/lcd-backlight/brightness";

char const*const ALS_FILE	= "/sys/class/leds/lcd-backlight/als/enable";
