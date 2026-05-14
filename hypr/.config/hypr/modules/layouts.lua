--------------
-- MONITORS --
--------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- top monitor 
hl.monitor({
    output   = "DP-4",
    mode     = "1920x1080@120",
    position = "0x0",
    scale    = 1,
})

-- bottom monitor (directly below DP-4)
hl.monitor({
    output   = "DP-5",
    mode     = "1920x1080@60",
    position = "0x1080",
    scale    = 1,
})

-- portrait on the right of both (90° rotation)
hl.monitor({
    output    = "HDMI-A-1",
    mode      = "1920x1080@60",
    position  = "1920x0",
    scale     = 1,
    transform = 3,
})

----------------
-- WORKSPACES --
----------------
local workspace = {
    { workspace = "1", monitor = "DP-4", default = true },
    { workspace = "2", monitor = "DP-5" },
    { workspace = "3", monitor = "HDMI-A-1", default = true },
}

--------------
-- WINDOWS --
--------------

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        -- preserve_split = true, -- You probably want this
        force_split = 2
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
-- hl.config({
--     master = {
--         new_status = "master",
--     },
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
-- hl.config({
--     scrolling = {
--         fullscreen_on_one_column = true,
--     },
-- })
