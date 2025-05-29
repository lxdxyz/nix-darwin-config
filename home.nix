{ config, pkgs, ... }:

{ 
  programs.home-manager.enable = true;  
  home.stateVersion = "25.05";
  
  programs.git = {
    enable = true;
    userName = "lxdxyz";
    userEmail = "github@lxdxyz.com";
  };
  programs.zsh = {
    enable = true;
    initContent = ''
      eval "$(mise activate zsh)"
    ''; 
  };

}
