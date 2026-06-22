local theme = _G.theme or {}

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = string.format("rgba(%se6)", theme.primary or "83d5c6"),
      inactive_border = "rgba(2E3440fe)",
    },
    layout = "dwindle",
    allow_tearing = true,
  },

  misc = {
    disable_hyprland_logo = true,
  },

  decoration = {
    rounding = 13,
    blur = {
      enabled = true,
      size = 7,
      passes = 4,
      new_optimizations = true,
    },
  },

  animations = {
    enabled = false,
  },
})

-- Keep curve/animation presets for easy future re-enable,
-- while preserving current behavior (animations disabled).
hl.curve("myBezier", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })
hl.curve("decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
