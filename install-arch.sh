#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
STATE_DIR="${HOME}/.local/state/dotfiles-install"
LOG_DIR="${STATE_DIR}/logs"
mkdir -p "${LOG_DIR}"

PACMAN_PACKAGES=(
    git
    github-cli
    base-devel
    rsync
    curl
    jq
    neovim
    fish
    foot
    kitty
    tmux
    wl-clipboard
    blueman
    network-manager-applet
    pulsemixer
    calcurse
    qalculate-qt
    fastfetch
    fzf
    fd
    zoxide
    starship
    bat
    dunst
    playerctl
    python
    ripgrep
    qt6ct
    qt6-wayland
    ttf-jetbrains-mono-nerd
    ttf-roboto
    noto-fonts-emoji
    networkmanager
    pipewire
    wireplumber
    brightnessctl
    ddcutil
    hyprlock
    hyprpicker
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    fuzzel
    cliphist
    yazi
    wlogout
    wf-recorder
    pavucontrol
    nwg-look
    upower
    imagemagick
    opencode
)

AUR_PACKAGES=(
    sesh
    tmuxifier
    xremap
    bluetui
    wifitui
    lazydocker
    otf-san-francisco
    hyprpolkitagent
    rose-pine-hyprcursor
    xdg-desktop-portal-termfilechooser
)

CONFIG_ITEMS=(
    calcurse
    dunst
    fastfetch
    fish
    foot
    fuzzel
    hypr
    kitty
    lazygit
    qalculate
    sesh
    systemd
    tmux
    xremap
    yazi
    starship.toml
)

PACMAN_MISSING=()
AUR_MISSING=()
REQUIRED_PACMAN_PACKAGES=(
    fish
    foot
    kitty
    tmux
    wl-clipboard
    waybar
    network-manager-applet
    blueman
    pulsemixer
    calcurse
    qalculate-qt
    playerctl
    hyprlock
    hyprpicker
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    fuzzel
    cliphist
    yazi
)
REQUIRED_AUR_PACKAGES=(
    sesh
    tmuxifier
    xremap
)
REQUIRED_COMMANDS=(
    fish
    foot
    kitty
    tmux
    yazi
    fuzzel
    cliphist
    sesh
    xremap
    # caelestia
    hyprlock
    hyprpicker
    wl-copy
    wl-paste
    nm-applet
    blueman-applet
    pulsemixer
    calcurse
    qalculate-qt
    playerctl
)
REQUIRED_FILES=(
    "${CONFIG_HOME}/hypr/hyprland.lua"
    "${CONFIG_HOME}/hypr/conf/autostart.lua"
    "${CONFIG_HOME}/hypr/bin/hyprlock/battery.sh"
    "${CONFIG_HOME}/hypr/bin/hyprlock/player.sh"
    "${CONFIG_HOME}/xremap/config.yml"
    "${CONFIG_HOME}/systemd/user/xremap.service"
    # "${CONFIG_HOME}/quickshell/caelestia"
    "${CONFIG_HOME}/nvim/init.lua"
)

log() {
    printf '[install] %s\n' "$*"
}

warn() {
    printf '[install][warn] %s\n' "$*" >&2
}

die() {
    printf '[install][error] %s\n' "$*" >&2
    exit 1
}

require_user() {
    if [[ "${EUID}" -eq 0 ]]; then
        printf 'Run this script as your regular user, not root.\n' >&2
        exit 1
    fi
}

have_cmd() {
    command -v "$1" >/dev/null 2>&1
}

install_pacman_packages() {
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        if pacman -Qq "${pkg}" >/dev/null 2>&1; then
            continue
        fi

        log "Installing pacman package: ${pkg}"
        if ! sudo pacman -S --needed --noconfirm "${pkg}"; then
            warn "Failed to install pacman package: ${pkg}"
            PACMAN_MISSING+=("${pkg}")
        fi
    done
}

bootstrap_paru() {
    if have_cmd paru; then
        return
    fi

    log 'Bootstrapping paru'
    sudo pacman -S --needed --noconfirm git base-devel

    local tmp_dir
    tmp_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru.git "${tmp_dir}/paru"
    (
        cd "${tmp_dir}/paru"
        makepkg -si --noconfirm
    )
    rm -rf "${tmp_dir}"
}

install_aur_packages() {
    if ! have_cmd paru; then
        warn 'paru is unavailable; skipping AUR package installation'
        AUR_MISSING=("${AUR_PACKAGES[@]}")
        return
    fi

    for pkg in "${AUR_PACKAGES[@]}"; do
        if paru -Qq "${pkg}" >/dev/null 2>&1; then
            continue
        fi

        log "Installing AUR package: ${pkg}"
        if ! paru -S --needed --noconfirm "${pkg}"; then
            warn "Failed to install AUR package: ${pkg}"
            AUR_MISSING+=("${pkg}")
        fi
    done
}

array_contains() {
    local needle="$1"
    shift

    local item
    for item in "$@"; do
        if [[ "${item}" == "${needle}" ]]; then
            return 0
        fi
    done

    return 1
}

sync_configs() {
    mkdir -p "${CONFIG_HOME}"

    for item in "${CONFIG_ITEMS[@]}"; do
        local src dst
        src="${SCRIPT_DIR}/${item}"
        dst="${CONFIG_HOME}/${item}"

        if [[ ! -e "${src}" ]]; then
            warn "Skipping missing config item: ${item}"
            continue
        fi

        if [[ -d "${src}" ]]; then
            mkdir -p "${dst}"
            case "${item}" in
                fish)
                    rsync -a --delete \
                        --exclude 'fish_variables' \
                        --exclude 'conf.d/fish_frozen_key_bindings.fish' \
                        --exclude 'conf.d/fish_frozen_theme.fish' \
                        "${src}/" "${dst}/"
                    ;;
                lazygit)
                    rsync -a --delete --exclude 'state.yml' "${src}/" "${dst}/"
                    ;;
                *)
                    rsync -a --delete "${src}/" "${dst}/"
                    ;;
            esac
        else
            install -Dm644 "${src}" "${dst}"
        fi
    done
}

patch_portable_paths() {
    log 'Patching copied configs for the current user'

    sed -i "s|/home/ewan|${HOME}|g" \
        "${CONFIG_HOME}/fish/config.fish" \
        "${CONFIG_HOME}/sesh/sesh.toml" || true

    sed -i "s|/run/media/ewan/|/run/media/${USER}/|g" \
        "${CONFIG_HOME}/yazi/keymap.toml" || true

    cat > "${CONFIG_HOME}/systemd/user/xremap.service" <<'EOF'
[Unit]
Description=xremap

[Service]
Restart=always
ExecStart=%h/.cargo/bin/xremap %h/.config/xremap/config.yml --watch

[Install]
WantedBy=default.target
EOF
}

install_tmux_helpers() {
    mkdir -p "${HOME}/.tmux/plugins"

    if [[ ! -d "${HOME}/.tmux/plugins/tpm/.git" ]]; then
        git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    fi

    if [[ ! -d "${HOME}/.tmuxifier/.git" ]]; then
        git clone https://github.com/jimeh/tmuxifier.git "${HOME}/.tmuxifier"
    fi
}

install_neovim_config() {
    if [[ -d "${CONFIG_HOME}/nvim/.git" ]]; then
        log 'Updating Neovim config'
        git -C "${CONFIG_HOME}/nvim" pull --ff-only
    else
        log 'Cloning Neovim config'
        rm -rf "${CONFIG_HOME}/nvim"
        git clone https://github.com/ratataque/neovim_config "${CONFIG_HOME}/nvim"
    fi

    if have_cmd nvim; then
        nvim --headless '+Lazy! sync' +qa >/dev/null 2>&1 || warn 'Neovim bootstrap did not finish cleanly; open nvim once manually.'
    fi
}

# install_caelestia_shell() {
#     mkdir -p "${CONFIG_HOME}/quickshell"
#
#     if [[ -d "${CONFIG_HOME}/quickshell/caelestia/.git" ]]; then
#         log 'Updating Caelestia shell config'
#         git -C "${CONFIG_HOME}/quickshell/caelestia" pull --ff-only
#     else
#         log 'Cloning Caelestia shell config'
#         rm -rf "${CONFIG_HOME}/quickshell/caelestia"
#         git clone https://github.com/caelestia-dots/shell.git "${CONFIG_HOME}/quickshell/caelestia"
#     fi
# }

set_default_shell_to_fish() {
    local fish_path
    fish_path="$(command -v fish || true)"

    if [[ -z "${fish_path}" ]]; then
        warn 'fish is not installed; skipping login shell change.'
        return
    fi

    if ! grep -Fxq "${fish_path}" /etc/shells; then
        log 'Adding fish to /etc/shells'
        printf '%s\n' "${fish_path}" | sudo tee -a /etc/shells >/dev/null
    fi

    if [[ "${SHELL:-}" == "${fish_path}" ]]; then
        return
    fi

    log 'Changing user login shell to fish'
    chsh -s "${fish_path}" || warn 'Failed to change login shell to fish. Run chsh -s "$(command -v fish)" manually.'
}

link_xremap_binary() {
    if ! have_cmd xremap; then
        warn 'xremap binary is still missing; the user service will not start until it is installed.'
        return
    fi

    mkdir -p "${HOME}/.cargo/bin"
    ln -sf "$(command -v xremap)" "${HOME}/.cargo/bin/xremap"
}

enable_user_services() {
    systemctl --user daemon-reload

    if [[ -f "${CONFIG_HOME}/xremap/config.yml" ]] && have_cmd xremap; then
        systemctl --user enable --now xremap.service || warn 'Failed to enable xremap.service'
    else
        warn 'Skipping xremap.service because xremap or its config is missing.'
    fi

    if systemctl --user list-unit-files 'hyprpolkitagent*' --no-legend 2>/dev/null | grep -q 'hyprpolkitagent'; then
        systemctl --user enable --now hyprpolkitagent.service || systemctl --user start hyprpolkitagent.service || warn 'Failed to start hyprpolkitagent.service'
    fi
}

finalize_permissions() {
    chmod +x \
        "${CONFIG_HOME}/hypr/xdg-portal-hyprland" \
        "${CONFIG_HOME}/hypr/bin/hyprlock/battery.sh" \
        "${CONFIG_HOME}/hypr/bin/hyprlock/player.sh" \
        "${CONFIG_HOME}/sesh/sesh.sh" \
        "${CONFIG_HOME}/tmux/scripts/cal.sh" \
        "${CONFIG_HOME}/tmux/scripts/tmux-sessionizer"

    mkdir -p "${HOME}/.cache"
    touch "${HOME}/.cache/current_wallpaper"
}

validate_required_components() {
    local failures=()
    local pkg
    local cmd
    local path

    for pkg in "${REQUIRED_PACMAN_PACKAGES[@]}"; do
        if array_contains "${pkg}" "${PACMAN_MISSING[@]}"; then
            failures+=("missing pacman package: ${pkg}")
        fi
    done

    for pkg in "${REQUIRED_AUR_PACKAGES[@]}"; do
        if array_contains "${pkg}" "${AUR_MISSING[@]}"; then
            failures+=("missing AUR package: ${pkg}")
        fi
    done

    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if ! have_cmd "${cmd}"; then
            failures+=("missing command: ${cmd}")
        fi
    done

    for path in "${REQUIRED_FILES[@]}"; do
        if [[ ! -e "${path}" ]]; then
            failures+=("missing file: ${path}")
        fi
    done

    if (( ${#failures[@]} > 0 )); then
        printf '[install][error] Installation is incomplete:\n' >&2
        printf '  - %s\n' "${failures[@]}" >&2
        return 1
    fi

    return 0
}

print_summary() {
    if (( ${#PACMAN_MISSING[@]} > 0 )); then
        warn "Missing pacman packages: ${PACMAN_MISSING[*]}"
    fi

    if (( ${#AUR_MISSING[@]} > 0 )); then
        warn "Missing AUR packages: ${AUR_MISSING[*]}"
    fi

    cat <<EOF

Install complete.

Next recommended steps:
  1. Log out and back in to Hyprland.
  2. Run 'nvim' once if plugins are still bootstrapping.

EOF
}

main() {
    require_user
    install_pacman_packages
    bootstrap_paru || warn 'Failed to bootstrap paru; continuing with pacman-only setup'
    install_aur_packages
    sync_configs
    patch_portable_paths
    install_tmux_helpers
    install_neovim_config
    # install_caelestia_shell
    link_xremap_binary
    set_default_shell_to_fish
    finalize_permissions
    enable_user_services
    validate_required_components || die 'Required packages or runtime files are missing. Fix the errors above and rerun install-arch.sh.'
    print_summary
}

main "$@"
