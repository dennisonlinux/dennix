{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "t440p";

  networking.networkmanager.enable = true;

  environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_QPA_PLATFORM = "wayland;xcb";
  };

  time.timeZone = "America/Phoenix";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.dennis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    librewolf
    wl-clipboard
    mako
    wofi
    kitty
    afetch
    cava
    cmatrix
    cbonsai
    bluetui
    nemo
    rose-pine-gtk-theme
    rose-pine-icon-theme
    rose-pine-cursor
    rose-pine-kvantum
    vimPlugins.rose-pine
    nwg-look
    libsForQt5.qt5ct
    kdePackages.qt6ct
    spotify
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  programs.sway.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

}

