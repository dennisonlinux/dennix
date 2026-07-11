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
    librewolf
    wl-clipboard
    swaynotificationcenter
    swaylock
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
    nix-search-cli
    libsForQt5.qt5ct
    libinput
    kdePackages.qt6ct
    spotify
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };

  programs.zsh.enable = true;

  programs.steam.enable = true;

  programs.regreet.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

}

