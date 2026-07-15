{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;
  hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
  };

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
  
  stylix = {
    enable = true;
    base16Scheme =  "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };

  users.users.dennis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };
  
  system.autoUpgrade = {
      enable = true;
      allowReboot = false;
      flake = "/home/dennis/dennix#t440p";
      dates = "daily";
  };

  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
  };

  nix.optimise = {
      automatic = true;
      dates = ["weekly"];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vivaldi
    wl-clipboard
    hyprlock
    hyprcursor
    swaybg
    grim
    slurp
    wofi
    kitty
    brightnessctl
    nitch
    cava
    cmatrix
    cbonsai
    bluetui
    nemo
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    gruvbox-kvantum
    quickshell
    vimPlugins.gruvbox
    libnotify
    nwg-look
    nix-search-cli
    xcur2png
    libsForQt5.qt5ct
    libinput
    kdePackages.qt6ct
    spotify
    playerctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  programs.hyprland.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

}

