{
  description = "My Nix/NixOS config";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";

    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs : {

    nixosConfigurations = {
      "Jeremy-nixos" = let opts = {nvidia = true; hostname = "Jeremy-nixos"; username = "jeremy"; wm = "i3"; device = "pc"; theme = "dracula"; }; in nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit inputs;
            userOptions = opts;
            # unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
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
                # unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
              };
            }
        ];
      };     

      "Jeremy-pc-hypr" = let opts = { nvidia = true; hostname = "Jeremy-nixos"; username = "jeremy"; wm = "hyprland"; device = "pc"; theme = "frappe"; }; in nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit inputs;
            userOptions = opts;
            # unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
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
                # unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
              };
            }
        ];
      };

      
      
    };
  };
}
