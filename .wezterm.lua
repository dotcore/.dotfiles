-- Pull in the wezterm module
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("GeistMono Nerd Font Mono")
-- config.font = wezterm.font("IosevkaTerm Nerd Font Mono")
config.font_size = 19
config.harfbuzz_features = { "liga=0" }

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

local act = wezterm.action

config.keys = {
	-- Clears the scrollback and viewport leaving the prompt line the new first line.
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }), -- This sends Ctrl+L to clear the viewport
		}),
	},
}

return config
