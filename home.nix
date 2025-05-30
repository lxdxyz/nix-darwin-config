{ config, pkgs, ... }:

{ 
  programs.home-manager.enable = true;  
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    neovim
    mise
    lazygit
  ];
  
  programs.vscode = {
    enable = true;
  };

  programs.wezterm = {
    enable =true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true; 
  };
  
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
