{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
           pkgs.vim
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      
      nixpkgs.config = {
        allowUnfree = true;
      };
      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        masApps = {
          WeChat = 836500024;
	  "WPS Office" = 1443749478;
        };
        casks = [
          "raycast"
          "betterdisplay"
          "zen"
          "firefox"
          "clash-verge-rev"
          "intellij-idea"
	  "visual-studio-code"
	  "1password"
        ];    
      };

    
      system.primaryUser = "lxdxyz";

      system.defaults = {
        dock = {
          # 自动隐藏dock
          autohide = true;
          # 隐藏应用透明
          showhidden = true;
          # 禁用最近项目
          show-recents = false;
          # 禁用运行中的应用指示器
          show-process-indicators = false;
          # 取消所有固定应用
          persistent-apps = [];
          # 固定在左侧   
          orientation = "left";
        };
        NSGlobalDomain = {
          InitialKeyRepeat = 25;
          KeyRepeat = 2;
          # 禁用 按键重复
          ApplePressAndHoldEnabled = false;
          # 自动隐藏顶部菜单栏
          _HIHideMenuBar = true;
          # 支持fn和小键盘默认是数字
          AppleKeyboardUIMode = 3;
          # 关闭鼠标自然滚动
          "com.apple.swipescrolldirection" = false;
          # 关闭智能破折号 将--替换——
          NSAutomaticDashSubstitutionEnabled = false;
          # 关闭智能句点
          NSAutomaticPeriodSubstitutionEnabled = false;
          # 关闭智能引号
          NSAutomaticQuoteSubstitutionEnabled = false;
          # 禁用自动大写
          NSAutomaticCapitalizationEnabled = false;
          # 保存文件使用详细列表视图
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          # 应用窗口调整大小速度
          NSWindowResizeTime = 0.001;
          # 默认保存文件到本地磁盘
          NSDocumentSaveNewDocumentsToCloud = false;
          # 滚动条点击跳转到点击位置
          AppleScrollerPagingBehavior = true;
          # 强制所有新窗口默认使用标签页模式
          AppleWindowTabbingMode = "always"; 
          
        };
      }; 
     
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#lycoris
    darwinConfigurations."lycoris" = nix-darwin.lib.darwinSystem {
      modules = [ 
                  configuration
		  home-manager.darwinModules.home-manager
		  {
                    users.users.lxdxyz.home = "/Users/lxdxyz";
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.extraSpecialArgs = {inherit inputs;};
		    home-manager.users.lxdxyz = ./home.nix;

		    # Optionally, use home-manager.extraSpecialArgs to pass
		    # arguments to home.nix
		  }
                ];
    };
  };
}
