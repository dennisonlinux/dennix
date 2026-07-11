{ config, pkgs, ... }:

{
    home.username = "dennis";
    home.homeDirectory = "/home/dennis";
    home.stateVersion = "26.05";

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      
      checkConfig = false;

      config = {
        modifier = "Mod4";
        terminal = "kitty";
      };

      extraConfig = ''
        shadows enable
        blur enable
        blur_passes 3
    '';
  };

    programs.zsh = {
       enable = true;
       shellAliases = {
         hi = "i'm dennis";
         nrs = "sudo nixos-rebuild switch --flake /home/dennis/dennix#t440p";
         nixconf = "vim /home/dennis/dennix/configuration.nix";
         homeconf = "vim /home/dennis/dennix/home.nix";
         flakeconf = "vim /home/dennis/dennix/flake.nix";
       };
       enableAutosuggestions = true;
       enableCompletion = true;
       initExtra = ''
         prompt off

         setopt PROMPT_SUBST

         PROMPT="[%F{blue}%f] [%F{green}%n%f@%F{cyan}%m%f] in [%F{yellow}%~%f]
         %F{magenta}>%f "
       '';
   };

   programs.vim = {
       enable = true;

       plugins = with pkgs.vimPlugins; [
         vim-nix
       ];
       extraConfig = ''
       filetype plugin indent on
       set expandtab
       set shiftwidth=4
       set softtabstop=4
       set tabstop=4
       set number
       set relativenumber
       set smartindent
       set showmatch
       set backspace=indent,eol,start
       syntax on
       autocmd BufWritePost *.nix silent !nixfmt %
     '';
   };
}
