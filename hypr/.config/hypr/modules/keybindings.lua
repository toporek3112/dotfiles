-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

local vars = require("modules.vars")

---------------------
------ MONITORS ------
---------------------
hl.bind("CTRL + ALT + " .. vars.keypad[1] , hl.dsp.dpms({ action = "toggle", monitor = vars.monitors.bottom }))
hl.bind("CTRL + ALT + " .. vars.keypad[2] , hl.dsp.dpms({ action = "toggle", monitor = vars.monitors.right }))
hl.bind("CTRL + ALT + " .. vars.keypad[3] , hl.dsp.dpms({ action = "toggle", monitor = vars.monitors.top }))

--------------------
--- APPLICATIONS ---
--------------------

hl.bind("CTRL + ALT + t", hl.dsp.exec_cmd("kitty"))
hl.bind(vars.keys.mainMod .. "+ ALT + R", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(vars.keys.mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(vars.keys.mainMod .. " + E", hl.dsp.exec_cmd(vars.apps.fileManager))
hl.bind(vars.keys.mainMod .. " + SPACE", hl.dsp.exec_cmd(vars.apps.menu))
hl.bind(vars.keys.mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.keys.mainMod .. " + D", hl.dsp.window.close())
hl.bind(vars.keys.mainMod .. " + R", hl.dsp.exec_cmd("~/dotfiles/waybar/.config/waybar/scripts/launch.sh"))
-- Screenshots
hl.bind(vars.keys.mainMod .. " + s", hl.dsp.exec_cmd("hyprshot -m window --freeze --raw  | satty -f -"))
hl.bind(vars.keys.mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("hyprshot -m region --freeze --raw  | satty -f -"))

-- hl.bind(vars.keys.mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(vars.keys.mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------
-- Maximize windows 
hl.bind(vars.keys.mainMod .. " + M",  hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
-- Move focus with mainMod + [h/j/k/l]
hl.bind(vars.keys.mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(vars.keys.mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.keys.mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(vars.keys.mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
-- Move windows with mainMod + SHIFT + [h/j/k/l]
hl.bind(vars.keys.mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
-- Resize windows with mainMod + CTRL + [h/j/k/l]
hl.bind(vars.keys.mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
-- Move focus with mainMod + [arrow keys]
hl.bind(vars.keys.mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(vars.keys.mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.keys.mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(vars.keys.mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))
-- Move windows with mainMod + SHIFT + [arrow keys]
hl.bind(vars.keys.mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(vars.keys.mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))
-- Resize windows with mainMod + CTRL + [arrow keys]
hl.bind(vars.keys.mainMod .. " + CTRL + LEFT", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + RIGHT", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + UP", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(vars.keys.mainMod .. " + CTRL + DOWN", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

for i = 1, 10 do
    local key = i % 10 -- still for the main number row

    -- main row: SUPER + [0-9]
    hl.bind(vars.keys.mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }))

    -- main row move
    hl.bind(vars.keys.mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }))

    -- numpad: SUPER + KP_*
    local kp = vars.keypad[i]
    if kp then
        hl.bind(vars.keys.mainMod .. " + " .. kp,
            hl.dsp.focus({ workspace = i }))

        hl.bind(vars.keys.mainMod .. " + SHIFT + " .. kp,
            hl.dsp.window.move({ workspace = i }))
    end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(vars.keys.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.keys.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move window silently (stay on current workspace)
-- hl.bind("CTRL + ALT + up", hl.dsp.window.move({ direction = "up" }))
-- hl.bind("CTRL + ALT + down", hl.dsp.window.move({ direction = "down" }))
-- hl.bind("CTRL + ALT + right", hl.dsp.window.move({ direction = "right" }))
-- hl.bind("CTRL + ALT + left", hl.dsp.window.move({ direction = "left" }))
-- hl.bind(vars.keys.mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "+1", follow = true }))
-- hl.bind(vars.keys.mainMod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "-1", follow = true }))

-- debug
-- hl.bind(vars.keys.mainMod .. " + ALT + M", function()
--   hl.notification.create({
--     text = "keybind fired!",
--     timeout = 3000,
--     icon = "ok"
--   })
-- end)

----------------
--- KEYBOARD ---
----------------
-- Keyboard multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
---- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Example special workspace (scratchpad)
-- hl.bind(vars.keys.mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(vars.keys.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(vars.keys.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(vars.keys.mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- logitech mouse side buttons 
-- hl.bind(vars.keys.mainMod .. " + mouse:275", hl.dsp.focus({ workspace = "e-1" })) -- back
-- hl.bind(vars.keys.mainMod .. " + mouse:276", hl.dsp.focus({ workspace = "e+1" })) -- forward