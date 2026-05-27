--------------------
------ MONITORS ------
---------------------

local monitors = require("modules.vars").monitors

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- top monitor 
hl.monitor({
    output   = monitors.top,
    mode     = "1920x1080@120",
    position = "0x0",
    scale    = 1,
})

-- bottom monitor (directly below DP-4)
hl.monitor({
    output   = monitors.bottom,
    mode     = "1920x1080@60",
    position = "0x1080",
    scale    = 1,
})

-- portrait on the right of both (90° rotation)
hl.monitor({
    output    = monitors.right,
    mode      = "1920x1080@60",
    position  = "1920x0",
    scale     = 1,
    transform = 3,
})

-----------------------
------ WORKSPACES ------
-----------------------
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local workspace = {
    { workspace = "1", monitor = monitors.bottom, persistent = true,  default = true},
    { workspace = "2", monitor = monitors.bottom, persistent = true,  default = true },
    { workspace = "3", monitor = monitors.bottom, persistent = true,  default = true },
    { workspace = "4", monitor = monitors.top, persistent = true,  default = true},
    { workspace = "5", monitor = monitors.top, persistent = true, default = true},
    { workspace = "6", monitor = monitors.top, persistent = true,  default = true },
    { workspace = "7", monitor = monitors.right, persistent = true,  default = true, layout = "scrolling", layout_opts = { direction = "down" } },
    { workspace = "8", monitor = monitors.right, persistent = true,  default = true, layout = "scrolling", layout_opts = { direction = "down" } },
    { workspace = "9", monitor = monitors.right, persistent = true,  default = true, layout = "scrolling", layout_opts = { direction = "down" } },
}

for _, ws in ipairs(workspace) do
    hl.workspace_rule(ws)
end

--------------------
------ WINDOWS ------
--------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- window placing 
hl.window_rule({
    name  = "always-float",
    match = {
      class = ".*(satty).*",
    },
    float = true
})

-- default workspaces for applications
hl.window_rule({
    name  = "workspace-01",
    match = {
      class = "code-oss",
    },
    no_blur = true,
    workspace = "1",
})

hl.window_rule({
    name  = "workspace-02",
    match = {
    --   class = "kitty",
      initial_title = "Code %- OSS",
    },
    no_blur = true,
    workspace = "2",
})

hl.window_rule({
    name  = "workspace-04",
    match = {
    --   class = "kitty",
    },
    no_blur = true,
    workspace = "4",
})

hl.window_rule({
    name  = "workspace-07",
    match = {
      class = ".*(obsidian|kitty).*",
    },
    no_blur = true,
    scrolling_width = 0.6,
    workspace = "7",
})

hl.window_rule({
    name  = "workspace-08",
    match = {
      class = "(KeePass2|spotify|firefox)",
    },
    no_blur = true,
    workspace = "8",
})

hl.window_rule({
    name  = "workspace-09",
    match = {
      class = "firefox",
    },
    no_blur = true,
    workspace = "9",
})

-- Example window rules that are useful
local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-------------------
------- MISC -------
-------------------
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
