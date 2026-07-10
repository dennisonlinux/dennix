{ config, pkgs, ... }:

{
    home.username = "dennis";
    home.homeDirectory = "/home/dennis";
    home.stateVersion = "26.05";

    programs.zsh = {
       enable = true;
       shellAliases = {
         hi = "i'm dennis";
         nrs = "sudo nixos-rebuild switch --flake /home/dennis/dennix#t440p";
         nixconf = "vim /home/dennis/dennix/configuration.nix";
         homeconf = "vim /home/dennis/dennix/home.nix";
         flakeconf = "vim /home/dennis/dennix/flake.nix";
      };
  };
    programs.nh = {
        enable = true;

        clean = {
            enable = true;
            extraArgs = "--keep 3";
        };
    };
}
