{ config, pkgs, ... }:

{ 
  programs.home-manager.enable = true;  
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    
  ];

  programs.mise = {
    enable = true;
  };
  
  programs.vscode = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true; 
  };

  programs.lazygit = {
    enable = true;
  };

  programs.wezterm = {
    enable =true;
    extraConfig = ''
      local config = wezterm.config_builder()

      -- 设置仅一个标签时隐藏标签栏
      config.hide_tab_bar_if_only_one_tab = true

      -- 禁用标题栏但启用可调整大小的边框
      config.window_decorations = "RESIZE"

      -- 例如设置颜色、字体等
      config.font_size = 15.0
      config.color_scheme = "Dracula"

      return config
    '';
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
    autosuggestion = {
      enable =true;
    };
    syntaxHighlighting = {
      enable = true;
    };
  };

}
