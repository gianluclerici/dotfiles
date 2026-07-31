local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Aspetto condiviso
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.window_background_opacity = 0.96
config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false

-- Schede
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Finestra
config.initial_cols = 120
config.initial_rows = 32
config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

-- Migliora il riconoscimento di URL e percorsi
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Su Windows usa PowerShell 7.
-- Su macOS e Linux usa la shell predefinita dell'utente.
if wezterm.target_triple:find("windows") then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Scorciatoie portabili
config.keys = {
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({
      confirm = true,
    }),
  },
}

return config
