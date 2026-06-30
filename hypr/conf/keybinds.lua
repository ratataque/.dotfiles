local mainMod = "SUPER"

local function bind_exec(keys, cmd, opts)
    hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- Application launchers
bind_exec("SUPER + R", "kitty -e tmux -u")
bind_exec("SUPER + SHIFT + R", "kitty")
bind_exec("SUPER + E", "footclient yazi")
bind_exec("SUPER + W", "kitty -e ~/.config/sesh/sesh.sh")
bind_exec("SUPER + C", "QT_QPA_PLATFORM=wayland QT_SCALE_FACTOR=1 qalculate-qt")
bind_exec("SUPER + B", "footclient bluetui")
bind_exec("SUPER + Z", "footclient wifitui")
bind_exec("SUPER + COMMA", "footclient pulsemixer")
bind_exec("SUPER + T", "footclient calcurse")
bind_exec("SUPER + S", "hyprshot -m region")

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + G", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())
hl.bind("SUPER + SHIFT + V", hl.dsp.layout("togglesplit"))

-- System controls
bind_exec("SUPER + X", "wlogout --protocol layer-shell")
bind_exec("SUPER + SHIFT + B", "killall waybar; waybar")

-- Utilities
bind_exec("SUPER + P", "1password --quick-access")
bind_exec("SUPER + SHIFT + C", "hyprpicker | wl-copy")
bind_exec("SUPER + V", "cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy")
bind_exec("SUPER + SPACE", "fuzzel")
-- bind_exec("SUPER + A", "footclient btop")
-- bind_exec("SUPER + ALT + V", "pkill fuzzel || caelestia clipboard -d")
bind_exec("CTRL + SUPER + E", "fuzzel-emoji")
bind_exec("SUPER + RETURN", "footclient hyprmon")

bind_exec("CTRL + SUPER + L", "hyprlock")

-- Move focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

-- Move windows
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Split ratio (Dwindle layout message)
hl.bind("SUPER + MINUS", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind("SUPER + EQUAL", hl.dsp.layout("splitratio +0.1"), { repeating = true })
hl.bind("SUPER + SEMICOLON", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind("SUPER + APOSTROPHE", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- Workspaces and moves
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

for i = 1, 5 do
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = true }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))

-- Caelestia global binds
-- hl.bind("CTRL + SUPER + R", hl.dsp.global("caelestia:showall"))
-- hl.bind("CTRL + SUPER + L", hl.dsp.global("caelestia:lock"))
-- hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
-- hl.bind("SUPER + S", hl.dsp.global("caelestia:screenshotFreezeClip"))
-- hl.bind("SUPER + ALT + T", hl.dsp.global("caelestia:sidebar"))
-- hl.bind("CTRL + SUPER + T", hl.dsp.global("caelestia:refreshDevices"))
-- hl.bind("SUPER + T", hl.dsp.global("caelestia:dashboard"))
-- hl.bind("SUPER + SPACE", hl.dsp.global("caelestia:launcher"))
-- hl.bind("SUPER + O", hl.dsp.global("caelestia:clearNotifs"))
-- hl.bind("CTRL + SUPER + SPACE", hl.dsp.global("caelestia:mediaToggle"), { locked = true })

-- Special workspace toggles
-- bind_exec("SUPER + A", "caelestia toggle sysmon")
-- bind_exec("SUPER + N", "caelestia toggle todo")
-- bind_exec("SUPER + M", "caelestia toggle communication")
hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("communication"))
hl.bind("SUPER + A", hl.dsp.workspace.toggle_special("sysmon"))
-- bind_exec("SUPER + BACKSPACE", "caelestia toggle communication")

-- Brightness
-- hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- Volume
bind_exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true })
bind_exec("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true })
bind_exec("XF86AudioLowerVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-", { locked = true, repeating = true })

-- Notification test
bind_exec(
    "CTRL + SUPER + F12",
    "notify-send -u low -i dialog-information-symbolic 'Test notification' \"Here's a really long message to test truncation and wrapping\\nYou can middle click or flick this notification to dismiss it!\" -a 'Shell' -A 'Test1=I got it!' -A 'Test2=Another action'",
    { locked = true }
)

-- Mouse and workspace wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
