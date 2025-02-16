<div align="center"><img src="https://github.com/sxyazi/yazi/blob/main/assets/logo.png?raw=true" alt="Yazi logo" width="20%"/></div>
<div align="center"><h3 align="center">Timu macOS (dark & light) Flavors for <a href="https://github.com/sxyazi/yazi">Yazi</h3></div>

## 👀 Preview

<p align="center"><img src="timu-macos-dark.yazi/preview.png" width="100%"/></p>
<p align="center"><img src="timu-macos-light.yazi/preview.png" width="100%"/></p>

## 🎨 Installation

``` {.bash org-language="sh"}
git clone https://gitlab.com/aimebertrand/timu-macos-yazi.git
cd timu-macos-yazi
cp -r timu-macos-dark.yazi timu-macos-light.yazi ~/.config/yazi/flavors/
```

## ⚙️ Usage

Set the content of your `~/.config/yazi/theme.toml`{.verbatim}:

``` toml
[flavor]
dark = "timu-macos-dark"
light = "timu-macos-light"
```

See the [Yazi flavor documentation](https://yazi-rs.github.io/docs/flavors/overview) for more details.

## 📜 License

The flavors are MIT-licensed, and the included tmThemes are also MIT-licensed.

Check the [LICENSE](https://gitlab.com/aimebertrand/timu-macos-yazi/-/raw/main/timu-macos-dark.yazi/LICENSE) and [LICENSE-tmtheme](https://gitlab.com/aimebertrand/timu-macos-yazi/-/raw/main/timu-macos-dark.yazi/LICENSE-tmtheme) file for more details.
