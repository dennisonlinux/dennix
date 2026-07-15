{ config, pkgs, ... }:

{
    home.username = "dennis";
    home.homeDirectory = "/home/dennis";
    home.stateVersion = "26.05";
    
    programs.quickshell = {
      enable = true;
      package = pkgs.quickshell;
    };
    home.sessionVariables = {
      QML2_IMPORT_PATH = "$HOME/.nix-profile/lib/qt-6/qml:$HOME/.nix-profile/lib/qt-5/qml:/run/current-system/sw/lib/qt-6/qml:/run/current-system/sw/lib/qt-5/qml\${QML2_IMPORT_PATH:+:\$QML2_IMPORT_PATH}";
  };
    qt = {
      enable = true;
      platformTheme.name = "qtct"; 
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
       initContent = ''
         prompt off

         setopt PROMPT_SUBST

         PROMPT="[%F{blue}%f] [%F{cyan}%n%f@%F{blue}%m%f] in [%F{cyan}%~%f]
         %F{blue}>%f "

         nitch
       '';
     };

     wayland.windowManager.hyprland.systemd.variables = ["--all"];


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
