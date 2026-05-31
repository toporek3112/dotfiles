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
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local workspaces = {
    -- special workspaces
    { workspace = "special:spotify", monitor = monitors.right,  default = true, on_created_empty = "flatpak run com.spotify.Client"},
    -- normal workspaces
    { workspace = "1", monitor = monitors.bottom, persistent = true,  default = true},
    { workspace = "2", monitor = monitors.bottom, persistent = true,  default = true },
    { workspace = "3", monitor = monitors.bottom, persistent = true,  default = true },
    { workspace = "4", monitor = monitors.top, persistent = true,  default = true},
    { workspace = "5", monitor = monitors.top, persistent = true, default = true},
    { workspace = "6", monitor = monitors.top, persistent = true,  default = true },
    { workspace = "7", monitor = monitors.right, persistent = true,  default = true },
    { workspace = "8", monitor = monitors.right, persistent = true,  default = true },
    { workspace = "9", monitor = monitors.right, persistent = true,  default = true },
    -- other
    { workspace = "m[" .. monitors.right .. "]", layout = "scrolling", layout_opts = { direction = "down" }}
}

for _, workspace in ipairs(workspaces) do
    hl.workspace_rule(workspace)
end

--------------------
------ WINDOWS ------
--------------------
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local windows = {
    -- window placing 
    { name  = "always-float", match = { class = ".*(satty).*" }, float = true },
    -- default special workspaces for applications
    {name  = "spotify", match = { class = "(spotify)" }, workspace = "special:spotify"},
    -- default normal workspaces for applications
    { name  = "workspace-01", match = { class = "code-oss"}, no_blur = true, workspace = "1" },
    { name  = "workspace-02",match = { initial_title = "Code %- OSS" }, no_blur = true, workspace = "2" },
    { name  = "workspace-04", match = { }, no_blur = true, workspace = "4" },
    { name  = "workspace-07", match = { class = ".*(obsidian|kitty|KeePass2).*" }, no_blur = true, scrolling_width = 0.6, workspace = "7" },
    { name  = "workspace-09", match = { class = "firefox" }, no_blur = true, workspace = "9", },
    ---- Example window rules that are useful
    -- Ignore maximize requests from all apps. You'll probably like this.
    { name  = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize",},
    -- Fix some dragging issues with XWayland
    { name  = "fix-xwayland-drags", match = { class      = "^$", title      = "^$", xwayland   = true, float      = true, fullscreen = false, pin = false }, no_focus = true,
    -- Layer rules also return a handle.
    -- https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
    -- local overlayLayerRule = hl.layer_rule({ name  = "no-anim-overlay", match = { namespace = "^my-overlay$" }, no_anim = true, })
    -- overlayLayerRule:set_enabled(false)
}
}

for _, window in ipairs(windows) do
    hl.window_rule(window)
end

-------------------
------- MISC -------
-------------------
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
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
