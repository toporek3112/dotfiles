local vars = {
    keys = {
        mainMod = "SUPER",
    },
    apps = {
        terminal    = "kitty",
        fileManager = "nautilus",
        menu        = "wofi --show run --style ~/.config/wofi/style.css",
    },
    monitors = {
        top    = "desc:Samsung Electric Company C27FG70 HTHJ400809",
        bottom = "desc:Samsung Electric Company C27FG70 HTHJ301585",
        right  = "desc:Samsung Electric Company SAMSUNG 0x01000E00",
    },
    keypad = {
        [1]  = "KP_End",
        [2]  = "KP_Down",
        [3]  = "KP_Next",
        [4]  = "KP_Left",
        [5]  = "KP_Begin",
        [6]  = "KP_Right",
        [7]  = "KP_Home",
        [8]  = "KP_Up",
        [9]  = "KP_Prior",
        [10] = "KP_Insert",
    }
}

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "10")
hl.env("HYPRCURSOR_SIZE", "10")

return vars
