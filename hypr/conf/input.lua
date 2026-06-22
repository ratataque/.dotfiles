hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    repeat_delay = 200,
    repeat_rate = 35,

    sensitivity = 0.2,
    accel_profile = "flat",
    force_no_accel = false,

    touchpad = {
      natural_scroll = true,
    },
  },
})

hl.config({
  cursor = {
    inactive_timeout = 0,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
