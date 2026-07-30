local home = os.getenv("HOME")
local script_path = home .. "/.config/hypr/scripts"

local active_opacity = 0.9

-- Env --

local cursor_theme = "phinger-cursors-dark"
local cursor_size = tostring(22)

hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_THEME", cursor_theme)
hl.env("HYPRCURSOR_SIZE", cursor_size)

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("HYPRSHOT_DIR", home .. "/Pictures/Screenshots")

-- Monitor --

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "0x0", scale = "1" })
hl.monitor({ output = "DP-1", mode = "1680x1050", position = "1920x0", scale = "1" })

-- Devices --

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

-- Autostart --

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hyprpolkitagent")
	hl.exec_cmd("mako")
	hl.exec_cmd("thunar --daemon")
	hl.exec_cmd("waybar")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wlsunset -t 500 -T 6500 -l 53.89 -L 27.56")
	hl.exec_cmd("flatpak run net.hovancik.Stretchly")
	hl.exec_cmd("hyprctl dispatch exec [workspace 1 silent] " .. script_path .. "/run-terminal.sh")
	hl.exec_cmd("hyprctl dispatch exec [workspace 9 silent] spotify-launcher")
	hl.exec_cmd("hyprctl dispatch exec [workspace 10 silent] telegram-desktop")
end)

-- Options --

hl.config({
	ecosystem = {
		no_update_news = true,
	},
	general = {
		layout = "master",
		gaps_in = 1,
		gaps_out = 1,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
	},
	dwindle = {
		preserve_split = true,
	},
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.9,
		direction = "right",
	},
	cursor = {
		no_warps = true,
	},
	decoration = {
		active_opacity = active_opacity,
		inactive_opacity = 0.8,
		blur = {
			size = 16,
			passes = 2,
		},
	},
	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
		middle_click_paste = false,
		allow_session_lock_restore = true,
	},
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:caps_toggle",
		touchpad = {
			natural_scroll = true,
		},
	},
	gestures = {
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_cancel_ratio = 0.8,
	},
})

-- Animations --

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })

hl.animation({ leaf = "windows", speed = 0, enabled = false })
hl.animation({ leaf = "layers", speed = 0, enabled = false })
hl.animation({ leaf = "fade", speed = 0, enabled = false })
hl.animation({ leaf = "border", speed = 0, enabled = false })
hl.animation({ leaf = "borderangle", speed = 0, enabled = false })
hl.animation({ leaf = "specialWorkspace", speed = 0, enabled = false })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Bindings --

local main_mod = "SUPER"

-- Reload
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { locked = true })
-- Exit/sleep
hl.bind(main_mod .. " + SHIFT + Delete", hl.dsp.exit(), { locked = true })
hl.bind(main_mod .. " + End", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })

-- Window ops
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(main_mod .. " + SHIFT + Space", hl.dsp.exec_cmd("hyprctl dispatch togglefloating && hyprctl dispatch centerwindow"))

-- Launchers
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(script_path .. "/run-terminal.sh"))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd("rofi -show drun -show-icons -theme dmenu"))
hl.bind(main_mod .. " + SHIFT + D", hl.dsp.exec_cmd(script_path .. "/run-powermenu.sh"))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd(script_path .. "/run-wallchange.sh"))

-- Clipboard
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme window | cliphist decode | wl-copy"))

-- Waybar toggle/restart
hl.bind(main_mod .. " + W", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(main_mod .. " + SHIFT + W", hl.dsp.exec_cmd("killall -SIGKILL waybar; waybar; pgrep hyprpaper || hyprpaper"))

-- Monitor toggle
hl.bind(main_mod .. " + SHIFT + F1", hl.dsp.exec_cmd("hyprctl keyword monitor eDP-1,1920x1080,0x0,1"), { locked = true })

-- Focus
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + Down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + Right", hl.dsp.focus({ direction = "right" }))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Swap
hl.bind(main_mod .. " + h", hl.dsp.exec_cmd("hyprctl dispatch swapwindow left"))
hl.bind(main_mod .. " + j", hl.dsp.exec_cmd("hyprctl dispatch swapwindow down"))
hl.bind(main_mod .. " + k", hl.dsp.exec_cmd("hyprctl dispatch swapwindow up"))
hl.bind(main_mod .. " + l", hl.dsp.exec_cmd("hyprctl dispatch swapwindow right"))
hl.bind(main_mod .. " + Left", hl.dsp.exec_cmd("hyprctl dispatch swapwindow left"))
hl.bind(main_mod .. " + Down", hl.dsp.exec_cmd("hyprctl dispatch swapwindow down"))
hl.bind(main_mod .. " + Up", hl.dsp.exec_cmd("hyprctl dispatch swapwindow up"))
hl.bind(main_mod .. " + Right", hl.dsp.exec_cmd("hyprctl dispatch swapwindow right"))

-- Resize
hl.bind(main_mod .. " + R", hl.dsp.window.resize(), { mouse = true })
hl.bind(main_mod .. " + ALT + Left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive-60 0"))
hl.bind(main_mod .. " + ALT + h", hl.dsp.exec_cmd("hyprctl dispatch resizeactive-60 0"))
hl.bind(main_mod .. " + ALT + Right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 60 0"))
hl.bind(main_mod .. " + ALT + l", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 60 0"))
hl.bind(main_mod .. " + ALT + Up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -60"))
hl.bind(main_mod .. " + ALT + k", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -60"))
hl.bind(main_mod .. " + ALT + Down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0  60"))
hl.bind(main_mod .. " + ALT + j", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0  60"))

-- Scratchpad
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse (scroll)
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- Mouse (move/resize)
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume
hl.bind("KP_ADD", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("KP_SUBTRACT", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("CTRL + KP_SUBTRACT", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Laptop multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots (clip)
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --clipboard-only -m region"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot --clipboard-only -m window"))
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd("hyprshot --clipboard-only -m output -m active"))
-- Screenshots (file)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SHIFT + CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + " .. main_mod .. " + Print", hl.dsp.exec_cmd("hyprshot -m output -m active"))

-- Quick edit
local start_terminal = function(cmd)
	return hl.dsp.exec_cmd(script_path .. '/run-terminal.sh " ' .. cmd .. ' "')
end
hl.bind(main_mod .. " + F1", start_terminal("cd ~/.config/nvim && nvim init.lua"))
hl.bind(main_mod .. " + F2", start_terminal("cd ~/.config/hypr && nvim hyprland.lua"))

hl.window_rule({
	match = { class = "^(Gimp-)", title = "negative:^(GNU Image Manipulation Program)$" },
	center = true,
	min_size = { 450, 320 },
	max_size = { 1344, 756 },
})

-- Rules --

hl.workspace_rule({ workspace = "special:scratchpad", gaps_out = 25 })

hl.window_rule({
	match = { class = "^(Code|xdg-desktop-portal-gtk|firefox)$", title = "^(Open|File Upload)" },
	float = true,
	center = true,
	pin = true,
	size = { "50%", "45%" },
	min_size = { 450, 320 },
	max_size = { 1344, 756 },
})

hl.window_rule({
	match = { class = "^(firefox)$" },
	opacity = "1.0 override " .. active_opacity .. " override 1.0",
})

hl.window_rule({
	match = { class = "^(imv)$" },
	float = true,
})

hl.window_rule({
	match = { class = "^(qimgv)$" },
	float = true,
	size = { 1280, 720 },
})

hl.window_rule({
	match = { class = "^(Spotify)$" },
	workspace = "9",
})

hl.window_rule({
	match = { class = "^(org.telegram.desktop)$" },
	workspace = "10",
})

hl.window_rule({
	match = { class = "^(vesktop)$" },
	workspace = "10",
})

hl.window_rule({
	match = { class = "^(xwaylandvideobridge)$" },
	opacity = "0.0 override",
	no_anim = true,
	no_blur = true,
	no_initial_focus = true,
	max_size = { 1, 1 },
})

hl.window_rule({
	match = { class = "^(thunar)$", title = '^(Rename ".*")$' },
	float = true,
})
