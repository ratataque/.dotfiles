# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# My fish config. Not much to see here; just some pretty standard stuff.

### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.

########################################################################################### env
if test -f /etc/.env
    cat /etc/.env | while read line
        set -l env_var (string split -m 1 "=" $line)
        set -l env_name $env_var[1]
        set -l env_value $env_var[2]
        set -gx $env_name $env_value
    end
end
########################################################################################### env

set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

set -gx QT_QPA_PLATFORM wayland
set -gx XDG_CONFIG_HOME ~/.config
set -gx GTK_THEME Adwaita-dark

set -x RUSTPATH $HOME/.cargo
set -x PATH $PATH $RUSTPATH/bin
set -gx LIBCLANG_PATH "/home/ewan/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-19.1.2_20250225/esp-clang/lib"
set -gx PATH "/home/ewan/.rustup/toolchains/esp/xtensa-esp-elf/esp-14.2.0_20240906/xtensa-esp-elf/bin:$PATH"

# set -gx ANDROID_HOME ~/.config/.android
set -gx ANDROID_HOME ~/Android
set -gx ANDROID_SDK_ROOT ~/Android/Sdk
# set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx ANDROID_AVD_HOME ~/.config/.android/avd
# set -gx PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
# set -gx PATH $PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools

set -gx GTK_USE_PORTAL 1 # Force GTK apps to use XDG portals
set -gx GDK_BACKEND wayland

set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx QT_QPA_PLATFORM xcb

set -gx ELECTRON_OZONE_PLATFORM_HINT wayland
set -gx WLR_RENDERER vulkan
set -gx WLR_DRM_NO_ATOMIC 1

set -gx AMD_VULKAN_ICD RADV
set -gx VK_ICD_FILENAMES /usr/share/vulkan/icd.d/radeon_icd.x86_64.json

set -U fish_user_paths $HOME/.tmuxifier/bin $fish_user_paths
eval (tmuxifier init - fish)
alias tm="tmuxifier"
alias tmux="tmux -u"
alias discord="discord --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto &"
alias 1="1password"

alias cat="bat"

alias dots="git --git-dir=$HOME/.dotfiles --work-tree=$HOME/.config"

### EXPORT ###
# set -gx LC_ALL "C"
set -gx LC_ALL "en_US.UTF-8"
set -gx FONTCONFIG_PATH /etc/fonts/
# set -gx LANG "en_US.UTF-8"
# set -gx LANGUAGE "en_US.UTF-8"

set -gx RUST_BACKTRACE 1
set fish_greeting # Supresses fish's intro message
# set TERM "xterm-256color"                         # Sets the terminal type
set EDITOR nvim # $EDITOR use Emacs in terminal
set -gx EDITOR nvim # $EDITOR use Emacs in terminal
set VISUAL nvim # $VISUAL use Emacs in GUI mode
set -gx VISUAL nvim # $VISUAL use Emacs in GUI mode
set -gx NVIM_SESSIONS /sessions # $VISUAL use Emacs in GUI mode

set -gx XDG_CONFIG_DIRS "/home/ewan/.config/"

### SET MANPAGER
### Uncomment only one of these!

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

function share
    curl -F "file=@$argv" https://0x0.st | wl-copy
end
### "vim" as manpager
# set -x MANPAGER '/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### "nvim" as manpager
# set -x MANPAGER "nvim -c 'set ft=man' -"

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
fish_vi_key_bindings
fish_user_key_bindings

if status is-interactive
    # I'm trying to grow a neckbeard
    fish_vi_key_bindings
    # Set the cursor shapes for the different vi modes.

    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block
end

### END OF VI MODE ###fish
set -U FZF_CD_WITH_HIDDEN_COMMAND "fd -H -u --type d --exclude node_modules . \$dir"
bind -M insert \cf '__fzf_cd --hidden'
set -U FZF_OPEN_COMMAND "fd -H -u --type f --exclude node_modules . \$dir"
set -U FZF_TMUX 1
set -e FZF_COMPLETE 0
bind -M insert \t __fzf_complete
set -U FZF_ENABLE_OPEN_PREVIEW 0

bind -M insert \ed /home/ewan/go/bin/lazydocker

bind -M insert \e. "vim ."
bind -M insert \ee vim
bind -M insert \er yazi
bind -M insert \e\x20 __fish_list_current_token # my preferred listing
bind -e \el
bind -M insert \ea "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
bind -M insert \ez "pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

### SPARK ###

### FUNCTIONS ###
# Spark functions
function letters
    cat $argv | awk -vFS='' '{for(i=1;i<=NF;i++){ if($i~/[a-zA-Z]/) { w[tolower($i)]++} } }END{for(i in w) print i,w[i]}' | sort | cut -c 3- | spark | lolcat
    printf '%s\n' abcdefghijklmnopqrstuvwxyz ' ' | lolcat
end

function commits
    git log --author="$argv" --format=format:%ad --date=short | uniq -c | awk '{print $1}' | spark | lolcat
end

# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
# The bindings for !! and !$
if [ "$fish_key_bindings" = fish_vi_key_bindings ]

    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

### ALIASES ###
# \x1b[2J   <- clears tty
# \x1b[1;1H <- goes to (1, 1) (start)
# alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# root privileges
alias doas="doas --"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and emacs
alias vim='nvim'

alias code="~/VSCode-linux-x64/bin/code"

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first' # all files and dirs
alias ll='exa -l --color=always --group-directories-first' # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# pacman and yay
alias unpac='sudo pacman -Rcns' # update only standard pkgs
alias pac='sudo pacman -S' # update only standard pkgs
alias pacu='sudo pacman -Syu' # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu' # Refresh pkglist & update standard pkgs
alias yaysua='yay -Sua --noconfirm' # update only AUR pkgs (yay)
alias yayu='yay -Syu --noconfirm' # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm' # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm' # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages
alias pacl="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pacr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias yayl="yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S"
alias yayr="yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns"

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias gitrmcached='git rm --cached -r (git ls-files -i -c --exclude-from=".gitignore")'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# vpn
# alias grimaldev='sudo openvpn --config /etc/openvpn/client/ewan_grimaldev.ovpn'
alias vpn_maison='sudo openvpn --config /etc/openvpn/client/ewan_grimely.ovpn'
# alias grimaldev='sudo openvpn --config /etc/openvpn/client/grimaldev.ovpn'

alias ff='fastfetch'
### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
# colorscript random

zoxide init fish | source
### SETTING THE STARSHIP PROMPT ###
starship init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
