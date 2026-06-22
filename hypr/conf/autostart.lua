hl.on("hyprland.start", function()
  -- XDG portal and DE setup
  hl.exec_cmd("~/.config/hypr/xdg-portal-hyprland")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Auth agent
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- Tray/background services
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("systemctl --user start xremap")
  hl.exec_cmd("xsettingsd")
  hl.exec_cmd("foot --server")

  -- App startup
  hl.exec_cmd("1password --ozone-platform=x11 --disable-gpu-sandbox %U")
  hl.exec_cmd("chromium --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto")
  hl.exec_cmd("firefox --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto")
  hl.exec_cmd("kitty -e tmux -u new -s dev", { workspace = "4 silent" })
  hl.exec_cmd("notion-app --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto", { workspace = "5 silent" })

  -- GTK theme setup
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")

  hl.exec_cmd("caelestia shell -d")
end)
