-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Own config

-- Fix compatibility on hyprland
config.enable_wayland = false

-- Set colorscheme
config.color_scheme = "Catppuccin Frappé (Gogh)"

-- Font settings
config.font = wezterm.font("0xProto Nerd Font")
config.font_size = 11

-- Choose terminal
-- pwsh on windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- Note: On windows, special settings are needed:
	-- 1. Enable Accessibility > Visual Effects > Transparency effects
	-- 2. Get correct settings from https://github.com/wezterm/wezterm/issues/4145
	config.default_prog = { "pwsh", "-nologo" }
	config.window_background_opacity = 0
	config.win32_system_backdrop = "Tabbed"
else
	config.window_background_opacity = 0.85
	config.macos_window_background_blur = 30
end

-- Window setting/ appearance
config.window_decorations = "RESIZE"
config.enable_tab_bar = true

-- Key binds
-- Emulate tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER | SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.ShowTabNavigator,
	},
	{
		key = "&",
		mods = "LEADER | SHIFT", -- Shift needed to reach &
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "x",
		mods = "LEADER", -- Shift needed to reach &
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- Navigate panes
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

return config
