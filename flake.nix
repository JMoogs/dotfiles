{
  description = "My Nix/NixOS config";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";

    # Temporary until next hyprland version
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprlock.url = "github:hyprwm/hyprlock";
    # hyprlock.inputs.nixpkgs.follows = "nixpkgs";

    # hypridle.url = "github:hyprwm/hypridle";
    # hypridle.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs : {

    nixosConfigurations = {
      "Jeremy-nixos" = let opts = { 
        nvidia = true;
        hostname = "Jeremy-nixos";
        username = "jeremy";
        wm = "i3";
        device = "pc";
        theme = "frappe";
       }; in nixpkgs.lib.nixosSystem  {
        specialArgs = {inherit inputs;
            userOptions = opts;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${opts.username}" = import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                userOptions = opts;
              };
            }
        ];
      };     

      "Jeremy-pc-hypr" = let opts = {
        nvidia = true;
        hostname = "Jeremy-nixos";
        username = "jeremy";
        wm = "hyprland";
        device = "pc";
        theme = "frappe";
       }; in nixpkgs.lib.nixosSystem  {
        specialArgs = {inherit inputs;
            userOptions = opts;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${opts.username}"= import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                userOptions = opts;
              };
            }
        ];
      };

      "Jeremy-laptop-hypr" = let opts = { 
        nvidia = false;
        hostname = "Jeremy-nixos-laptop";
        username = "jeremy";
        wm = "hyprland";
        device = "laptop";
        theme = "frappe";
       }; in nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;
            userOptions = opts;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${opts.username}"= import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                userOptions = opts;
              };
            }
        ];
      };

      "Jeremy-laptop-i3" = let opts = { 
        nvidia = false;
        hostname = "Jeremy-nixos-laptop";
        username = "jeremy";
        wm = "i3";
        device = "laptop";
        theme = "frappe";
       }; in nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;
            userOptions = opts;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${opts.username}"= import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                userOptions = opts;
              };
            }
        ];
      };
      
      
    };
  };
}
