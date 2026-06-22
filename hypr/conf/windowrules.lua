-- Ordering matters for window/layer rules.

hl.window_rule({ match = { class = "foot|vesktop|equibop|imv|swappy" }, opaque = true })
hl.window_rule({ match = { float = true }, center = true })

hl.window_rule({ match = { class = "firefox" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "chromium" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "Notion" }, workspace = "5 silent" })

hl.window_rule({
  match = { title = "(Floating Window - Show Me The Key)" },
  float = true,
  border_size = 0,
  move = { 1033, 842 },
  size = { 491, 50 },
  pin = true,
})

hl.window_rule({ match = { class = "btop" }, workspace = "special:sysmon" })
hl.window_rule({ match = { class = "feishin|Spotify|Supersonic|Cider" }, workspace = "special:music" })
hl.window_rule({ match = { initial_title = "Spotify( Free)?" }, workspace = "special:music" })
hl.window_rule({ match = { class = "discord|equibop|vesktop|whatsapp" }, workspace = "special:communication" })
hl.window_rule({ match = { class = "Todoist" }, workspace = "special:todo" })

hl.window_rule({ match = { title = "(Select|Open)( a)? (File|Folder)(s)?" }, float = true })
hl.window_rule({ match = { title = "File (Operation|Upload)( Progress)?" }, float = true })
hl.window_rule({ match = { title = ".* Properties" }, float = true })
hl.window_rule({ match = { title = "Export Image as PNG" }, float = true })
hl.window_rule({ match = { title = "GIMP Crash Debug" }, float = true })
hl.window_rule({ match = { title = "Save As" }, float = true })
hl.window_rule({ match = { title = "Library" }, float = true })

hl.window_rule({ match = { class = "steam" }, rounding = 10 })
hl.window_rule({ match = { title = "Friends List", class = "steam" }, float = true })
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, immediate = true })
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, idle_inhibit = "always" })

hl.window_rule({ match = { title = "Fusion360|(Marking Menu)", class = "fusion360\\.exe" }, no_blur = true })

hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%" })
hl.layer_rule({ match = { namespace = "launcher" }, blur = true })

hl.window_rule({ match = { class = "footclient", title = "foot" }, float = true })
hl.window_rule({ match = { class = "footclient", title = "foot" }, size = { 1000, 700 } })
hl.window_rule({ match = { class = "footclient", title = "foot" }, center = true })

hl.window_rule({ match = { title = "Qalculate!" }, float = true })
hl.window_rule({ match = { title = "Qalculate!" }, size = { 1000, 700 } })
hl.window_rule({ match = { title = "Qalculate!" }, center = true })

hl.window_rule({ match = { class = "org\\.gnome\\.Settings" }, float = true })
hl.window_rule({ match = { class = "org\\.gnome\\.Settings" }, size = { "70%", "80%" } })
hl.window_rule({ match = { class = "org\\.gnome\\.Settings" }, center = true })

hl.window_rule({ match = { class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser" }, float = true })
hl.window_rule({ match = { class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser" }, size = { "60%", "70%" } })
hl.window_rule({ match = { class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser" }, center = true })

hl.window_rule({ match = { class = "nwg-look" }, float = true })
hl.window_rule({ match = { class = "nwg-look" }, size = { "50%", "60%" } })
hl.window_rule({ match = { class = "nwg-look" }, center = true })

hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })

hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-2" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "DP-2" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })
