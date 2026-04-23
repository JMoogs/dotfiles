# My NixOS + home-manager dotfiles

**NixOS version: Unstable**

The main thing this does beyond a standard NixOS setup is a single-variable theme system — `themingModule.theme` is the only value you change to switch themes, and `home/theming/getTheme.nix` propagates it everywhere (GTK, Neovim, Waybar CSS, Kitty, Zellij, Rofi, Dunst, Hyprland borders, lock screen wallpaper). Each theme is also baked into the bootloader as a separate entry via NixOS [specialisations](https://nixos.wiki/wiki/Specialisation).

## Setup

### General
- Themes: [Dracula](https://draculatheme.com/), [Catppuccin Frappe](https://catppuccin.com/), [Catppuccin Latte](https://catppuccin.com/)
- Window Manager: [Hyprland](https://hyprland.org/)
- Terminal: [Kitty](https://github.com/kovidgoyal/kitty)
- Shell: [Fish](https://fishshell.com/)
- Multiplexer: [Zellij](https://github.com/zellij-org/zellij)
- Editor: [Neovim](https://neovim.io/) via [NixVim](https://github.com/nix-community/nixvim)
- Browser: [Brave](https://brave.com/)
- Launcher: [Rofi](https://github.com/davatorium/rofi)

### Desktop
- Bar: [Waybar](https://github.com/Alexays/Waybar)
- Lock screen: [Hyprlock](https://github.com/hyprwm/hyprlock)
- Idle daemon: [Hypridle](https://github.com/hyprwm/hypridle)
- Notifications: [Dunst](https://github.com/dunst-project/dunst)
- Screenshots: [Grimblast](https://github.com/hyprwm/contrib)
- Wallpapers: [Waypaper](https://github.com/anufrievroman/waypaper)

### Utilities
- File manager: [Yazi](https://github.com/sxyazi/yazi)
- System monitor: [Bottom](https://github.com/ClementTsang/bottom)
- Media player: [mpv](https://mpv.io/) with sponsorblock, MPRIS, quality menu
- Image viewer: `kitten icat`
- PDF viewer: Firefox

## Notable bits

- **Neovim** is configured entirely through NixVim — the whole thing is a Nix module. LSPs: clangd, nil_ls, pyright, rust_analyzer, hls, metals, ts_ls, eslint, tinymist, jsonls.
- **Discord** plugins and themes are managed declaratively via [Nixcord](https://github.com/KaylorBen/nixcord) (Vencord on [Vesktop](https://github.com/Vencord/Vesktop)).
- **`pkgs/wayland-push-to-talk-fix.nix`** is a custom Nix package wrapping a C tool that remaps a mouse button to a virtual keypress, needed for Discord PTT on Wayland where button passthrough doesn't work natively.
- **`userOptions.device`** in `flake.nix` gates monitor layout, workspace bindings, battery widget, idle timeouts, and package lists — the same config targets both PC and laptop.
- **`scripts/shells/`** has per-language Nix dev shells for Rust, Python, C++, and Haskell. Enter any with `dev` (`nix-shell --command fish`).
- **Waybar** workspace labels are Japanese kanji (一二三…).

## Structure

```
flake.nix              userOptions (theme, device, nvidia, wm)
configuration.nix      system-level config
home.nix               home-manager entry point
home/
  theming/
    theming.nix        NixOS option: themingModule.theme
    getTheme.nix       maps theme name → all per-app configs
  hypr/                Hyprland + hyprlock + hypridle
  wm/                  Waybar + per-theme CSS + cava
  shell/               Fish, Kitty, Zellij
  neovim.nix
  discord.nix
modules/
  nvidia.nix           NVIDIA Wayland (explicit sync, VAAPI, container toolkit)
  jellyfin.nix         Jellyfin + Sonarr + Bazarr
hosts/main/            hardware config, bootloader, kernel (r8125 driver)
pkgs/                  custom package derivations
scripts/
  wallpaper_lutgen.sh  applies palette LUTs to source wallpapers via lutgen
  shells/              per-language nix-shells
```

## Installation

This config expects the repo at `/etc/nixos` — theme asset paths and the Zellij theme directory are hardcoded there.

```bash
sudo git clone <repo> /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-nixos
```

To change theme, set `theme` in `flake.nix` (`"frappe"`, `"latte"`, or `"dracula"`) and rebuild. The three themes are also available as separate bootloader entries without editing anything.

To target laptop instead of PC, set `device = "laptop"` in `flake.nix`.

**Wallpapers** (requires `lutgen` in `$PATH`, run from the `wallpapers/` directory):

```bash
bash ../scripts/wallpaper_lutgen.sh
```

Source images go in `wallpapers/originals/` (or `wallpapers/originals/anime/`). Already-converted files are skipped.
