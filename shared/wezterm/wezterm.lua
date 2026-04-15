-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Own config
-- Fix compatibility on hyprland
config.enable_wayland = false

-- Set colors
config.color_scheme = "Catppuccin Frappé (Gogh)"

-- Inactive pane styling
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.3,
}

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

-- Vim aware pane navigation
local function is_vim(pane)
	local proc = pane:get_foreground_process_name()
	return proc ~= nil and (proc:find("nvim") ~= nil or proc:find("vim") ~= nil)
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function smart_split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

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
	-- Tmux like navigation. Can also navigate out of nvim
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
	-- if nvim is in pane, let it use
	smart_split_nav("move", "h"),
	smart_split_nav("move", "j"),
	smart_split_nav("move", "k"),
	smart_split_nav("move", "l"),
	-- pane sizes
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
}

return config
