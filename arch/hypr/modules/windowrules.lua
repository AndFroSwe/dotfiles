hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Window rules for clipboard
hl.window_rule({
	match = { initial_title = "clipse" },
	float = true,
	size = { 1000, 800 },
	center = true,
})

-- Pavu control
hl.window_rule({
	match = { class = ".*pavucontrol.*" },
	float = true,
	size = { 1100, 800 },
})

-- Terminal windows
-- To launch a terminal application as floating, set the launch commandwith title *-float, like this
-- kitty --title nmtui-float nmtui
hl.window_rule({
	match = { initial_class = "kitty", initial_title = ".*-float" },
	float = true,
	size = { 1100, 800 },
})
