{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    
      system.primaryUser = "lxdxyz"; 

      system.defaults = {
        NSGlobalDomain = {
          InitialKeyRepeat = 10;
          KeyRepeat = 1;
        };
      }; 
     
      system.defaults.CustomUserPreferences = {
        "com.apple.dock" = {
          autohide = true;
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
		    home-manager.users.lxdxyz = ./home.nix;

		    # Optionally, use home-manager.extraSpecialArgs to pass
		    # arguments to home.nix
		  }
                ];
    };
  };
}
