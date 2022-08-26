{ inputs, pkgs, config, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    wf-recorder
    discord
    pfetch
    vlc
    nordzy-icon-theme
    bottom
    wofi
    mpv
    imv
    hyperfine
    waybar
    swappy
    gimp
    kdenlive
    swaybg
    slurp
    grim
    pngquant
    wl-clipboard
    proxychains-ng
    exa
    ffmpeg
    unzip
    libnotify
    gnupg
    yt-dlp
    ripgrep
    rsync
    imagemagick
    unrar
    tealdeer
    killall
    du-dust
    bandwhich
    grex
    fd
    xh
    jq
    figlet
    lm_sensors
    keepassxc
    minecraft
    python3
    git
    jdk
    dconf
    gcc
    rustc
    rustfmt
    cargo
  ];
}
