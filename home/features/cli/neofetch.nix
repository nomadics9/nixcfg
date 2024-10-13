{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.features.cli.neofetch;
  neofetchConfig = ''
    print_info() {
        info "\033[1;32m ╭─󱄅 " distro   # cl2 (green)
        info "\033[1;32m ├─" kernel     # cl2 (green)
        info "\033[1;32m ├─" users      # cl2 (green)
        info "\033[1;32m ├─󰏗" packages   # cl2 (green)
        info "\033[1;32m ╰─" shell      # cl2 (green)
        echo
        info "\033[1;33m ╭─" de         # cl6 (yellow)
        info "\033[1;33m ├─" term       # cl6 (yellow)
        info "\033[1;33m ╰─" term_font  # cl6 (yellow)
        info "\033[1;33m ├─󰂫" theme      # cl6 (yellow)
        info "\033[1;33m ├─󰂫" icons      # cl6 (yellow)
        info "\033[1;33m ╰─" font       # cl6 (yellow)
        echo
        info "\033[1;34m ╭─" model      # cl4 (blue)
        info "\033[1;34m ├─󰍛" cpu        # cl4 (blue)
        info "\033[1;34m ├─󰍹" gpu        # cl4 (blue)
        info "\033[1;34m ├─" resolution # cl4 (blue)
        info "\033[1;34m ├─" memory     # cl4 (blue)
        info "\033[1;34m ├─ \033[0m" disk  # cl4 (blue), cl0 (reset)
        info "\033[1;34m ╰─󰄉" uptime     # cl4 (blue)
        prin " "
        prin " \n \n \n \n \n \n \033[1;37m \n \n \033[1;31m󱄅 \n \n \033[1;32m  \n \n \033[1;33m󱄅  \n \n \033[1;34m  \n \n \033[1;35m󱄅  \n \n \033[1;36m  \n \n \033[0m󱄅  \n \n "
    }


    title_fqdn="on"
    kernel_shorthand="on"
    distro_shorthand="on"
    os_arch="off"
    uptime_shorthand="tiny"
    memory_percent="on"
    memory_unit="Gib"
    package_managers="on"
    shell_path="off"
    shell_version="on"
    speed_type="scaling_max_freq"
    speed_shorthand="on"
    cpu_brand="on"
    cpu_speed="on"
    cpu_cores="logical"
    cpu_temp="on"
    gpu_brand="on"
    gpu_type="all"
    refresh_rate="on"
    gtk_shorthand="off"
    gtk2="off"
    gtk3="off"
    public_ip_host="http://ident.me"
    public_ip_timeout=2
    de_version="on"
    disk_show=('/home')
    disk_subtitle="mount"
    disk_percent="on"
    music_player="auto, amberol"
    song_format="%artist% - %album% - %title%"
    song_shorthand="off"
    mpc_args=()
    colors=(distro)
    bold="on"
    underline_enabled="on"
    underline_char="󰍴"
    separator=" "
    block_range=(1 8)
    magenta="\033[1;35m"
    green="\033[1;32m"
    white="\033[1;37m"
    blue="\033[1;34m"
    red="\033[1;31m"
    black="\033[1;40;30m"
    yellow="\033[1;33m"
    cyan="\033[1;36m"
    reset="\033[0m"
    bgyellow="\033[1;43;33m"
    bgwhite="\033[1;47;37m"
    color_blocks="on"
    block_width=4
    block_height=1
    col_offset="auto"
    bar_char_elapsed="-"
    bar_char_total="="
    bar_border="on"
    bar_length=15
    bar_color_elapsed="distro"
    bar_color_total="distro"
    cpu_display="on"
    memory_display="on"
    battery_display="on"
    disk_display="on"
    image_backend="kitty"
    image_source="${config.home.homeDirectory}/nixcfg/assets/logo.png"
    ascii_distro="off"
    ascii="off"
    ascii_colors=(distro)
    ascii_bold="on"
    image_loop="on"
    thumbnail_dir="${config.xdg.cacheHome}/thumbnails/neofetch"
    crop_mode="normal"
    crop_offset="center"
    image_size="500px"
    gap=2
    yoffset=1
    xoffset=0
    background_color=
    stdout="off"

  '';
in
{
  options.features.cli.neofetch.enable = mkEnableOption "enable neofetch";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ neofetch ];
    home.file.".config/neofetch/config.conf".text = lib.mkForce neofetchConfig;
  };
}
