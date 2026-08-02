local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Aspetto condiviso
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Symbols Nerd Font Mono",
})
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

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- PowerShell 7 su Windows; shell predefinita su macOS e Linux
if wezterm.target_triple:find("windows") then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Scorciatoie portabili
config.keys = {
  -- Split orizzontale
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "d",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },

  -- Split verticale
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "e",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({
      domain = "CurrentPaneDomain",
    }),
  },

  -- Chiude il pannello attivo
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({
      confirm = true,
    }),
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane({
      confirm = true,
    }),
  },
}

return config
