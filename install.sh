#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
dry_run=0
skip_packages=0
skip_firefox=0
skip_wallpapers=0
backup_root="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]
  --dry-run          show actions without changing the system
  --no-packages      skip pacman and AUR packages
  --no-firefox       skip Firefox chrome CSS
  --no-wallpapers    skip bundled wallpapers
EOF
}

say() { printf '[dotfiles] %s\n' "$*"; }
run() {
    if ((dry_run)); then printf '+ %s\n' "$*"; else "$@"; fi
}

copy_file() {
    local source="$1" destination="$2" backup
    if [[ -f "$destination" ]] && cmp -s "$source" "$destination"; then return; fi
    if [[ -e "$destination" || -L "$destination" ]]; then
        backup="${backup_root}${destination}"
        run mkdir -p "$(dirname "$backup")"
        run mv "$destination" "$backup"
        say "backup: $destination -> $backup"
    fi
    run mkdir -p "$(dirname "$destination")"
    run cp "$source" "$destination"
    say "installed: $destination"
}

copy_tree() {
    local source_dir="$1" destination_dir="$2" source relative
    while IFS= read -r -d '' source; do
        relative="${source#"$source_dir"/}"
        copy_file "$source" "$destination_dir/$relative"
    done < <(find "$source_dir" -type f -not -path '*/.git/*' -print0 | sort -z)
}

install_packages() {
    ((skip_packages)) && return
    if ! command -v pacman >/dev/null 2>&1; then
        say 'pacman not found; skipping Arch packages'
        return
    fi

    local -a packages aur_packages
    mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$repo_root/packages/arch.txt")
    if ((dry_run)); then
        printf '+ sudo pacman -Syu --needed %s\n' "${packages[*]}"
    else
        sudo pacman -Syu --needed "${packages[@]}"
    fi

    mapfile -t aur_packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$repo_root/packages/aur.txt")
    local helper=''
    if command -v paru >/dev/null 2>&1; then helper=paru; elif command -v yay >/dev/null 2>&1; then helper=yay; fi
    if [[ -n "$helper" ]]; then
        if ((dry_run)); then printf '+ %s -S --needed %s\n' "$helper" "${aur_packages[*]}"; else "$helper" -S --needed "${aur_packages[@]}"; fi
    else
        say 'yay/paru not found; skipping optional AUR package vial-appimage'
    fi
}

install_configs() {
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    copy_tree "$repo_root/config/hypr" "$config_home/hypr"
    copy_tree "$repo_root/config/waybar" "$config_home/waybar"
    copy_tree "$repo_root/config/rofi" "$config_home/rofi"
    copy_tree "$repo_root/config/kitty" "$config_home/kitty"
    copy_tree "$repo_root/config/nvim" "$config_home/nvim"
    copy_tree "$repo_root/config/firefox" "$config_home/dotfiles-firefox"
    copy_tree "$repo_root/config/swaync" "$config_home/swaync"
    copy_file "$repo_root/config/mako-config" "$config_home/mako/config"
    copy_file "$repo_root/config/swappy-config" "$config_home/swappy/config"
    copy_file "$repo_root/config/herdr.toml" "$config_home/herdr/config.toml"
    copy_file "$repo_root/config/yazi-theme.toml" "$config_home/yazi/theme.toml"
    copy_file "$repo_root/keyboard/layout.vil" "$HOME/Documents/Keyboard/layout.vil"
    copy_file "$repo_root/home/.bashrc" "$HOME/.bashrc"
    copy_file "$repo_root/home/.profile" "$HOME/.profile"
    copy_file "$repo_root/home/.zshrc" "$HOME/.zshrc"
    copy_file "$repo_root/home/config.fish" "$config_home/fish/config.fish"
    copy_file "$repo_root/home/starship.toml" "$config_home/starship.toml"
    copy_tree "$repo_root/fonts/GeistMono" "$HOME/.local/share/fonts/GeistMono"
    run fc-cache -f "$HOME/.local/share/fonts"

    local script
    while IFS= read -r -d '' script; do
        copy_file "$script" "$HOME/.local/bin/$(basename "$script")"
        run chmod 755 "$HOME/.local/bin/$(basename "$script")"
    done < <(find "$repo_root/bin" -maxdepth 1 -type f -print0 | sort -z)
}

install_wallpapers() {
    ((skip_wallpapers)) && return
    local wallpaper
    while IFS= read -r -d '' wallpaper; do
        copy_file "$wallpaper" "$HOME/.local/share/wallpapers/$(basename "$wallpaper")"
    done < <(find "$repo_root/wallpapers" -maxdepth 1 -type f -print0 | sort -z)
}

install_firefox() {
    ((skip_firefox)) && return
    local firefox_dir="$HOME/.mozilla/firefox"
    [[ -d "$firefox_dir" ]] || { say 'Firefox profile not found; CSS is under ~/.config/dotfiles-firefox'; return; }
    local -a profiles
    mapfile -t profiles < <(find "$firefox_dir" -mindepth 1 -maxdepth 1 -type d -name '*.default*' -print | sort)
    if ((${#profiles[@]} != 1)); then
        say 'Firefox has zero or multiple profiles; copy CSS manually from ~/.config/dotfiles-firefox'
        return
    fi
    run mkdir -p "${profiles[0]}/chrome"
    copy_file "$repo_root/config/firefox/userChrome.css" "${profiles[0]}/chrome/userChrome.css"
    copy_file "$repo_root/config/firefox/sideberry.css" "${profiles[0]}/chrome/sideberry.css"
    say 'enable toolkit.legacyUserProfileCustomizations.stylesheets in about:config'
}

enable_audio() {
    ((dry_run || skip_packages)) && return
    systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || say 'retry audio services after logging into Hyprland'
}

while (($#)); do
    case "$1" in
        --dry-run) dry_run=1 ;;
        --no-packages) skip_packages=1 ;;
        --no-firefox) skip_firefox=1 ;;
        --no-wallpapers) skip_wallpapers=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

install_packages
install_configs
install_wallpapers
install_firefox
enable_audio

say "done; backups are under ${backup_root} when replacements were needed"
say 'restart Hyprland or run `hyprctl reload` to activate the configuration'
