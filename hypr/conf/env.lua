-- Environment variables.
-- If you use UWSM, Hyprland recommends moving these into ~/.config/uwsm/env* files.

hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "24")
-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("XCURSOR_THEME", "BreezeX-Dark")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("HYPRLAND_NO_OSD", "1")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11")
