-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- The configuration
config:set_strict_mode(true) -- promote warnings to errors
config.enable_wayland = true
config.color_scheme = "nightfox"
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.window_decorations = "NONE"
config.window_padding = {
	top = 0,
	left = 0,
	right = 0,
	bottom = 0,
}

config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{ key = "t", mods = "ALT", action = wezterm.action.ShowTabNavigator },
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 2 }) },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 2 }) },
	{ key = "UpArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 2 }) },
	{ key = "DownArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 2 }) },
}
config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},

	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- And finally, return the configuration to wezterm
return config
