## 🚧 Guide will be written soon 🚧
### tldr: use the the installer after installing nixos


#### Layout
```
nixcfg/
├── home/
│   ├── common/
│   ├── features/
│   |   ├── cli
│   |       ├── fzf.nix
│   |       ├── neofetch.nix
│   |       ├── zsh.nix
│   |   ├── desktop/
│   |       ├── fonts.nix
│   |       ├── hyprland.nix
|   |       ├── wayland.nix
|   |       ├── xdg.nix
|   |   ├── themes/
|   |       ├── gtk.nix
|   |       ├── qt.nix
│   ├── nomad/
|       ├── dotfiles/
|           ├── bat.nix
|           ├── default.nix
|           ├── dunst.nix
|       ├── home.nix
|       ├── unknown.nix
│
├── hosts/
│   ├── common/
|   |   ├── services
|   |       ├── appimage.nix
|   |       ├── nautilus.nix
|   |       ├── polkit.nix
|   |       ├── steam.nix
|   |       ├── vm.nix
|   |       ├── xdgportal.nix
|   |   ├── users
|   |       ├── nomad.nix
│   ├── unkown/
│       ├── hardware/
|       |   ├── battery.nix
|       |   ├── nvidia.nix
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│
├── overlays/
├── pkgs/
├── flake.lock
├── flake.nix
├── install.sh
├── README.md
```
