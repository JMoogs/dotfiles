{
  description = "My Nix/NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager, a tool for declarative configuration of dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix version of neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixcord for Discord/Vencord declarative config
    nixcord = {
      url = "github:KaylorBen/nixcord";
    };

    # Nix user repository (NUR) for firefox extensions
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "Jeremy-nixos" = let
        opts = {
          username = "jeremy";
          device = "pc";
          theme = "frappe";
          nvidia = true;
          wm = "hyprland";
        };
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            userOptions = opts;
          };
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            ./modules/nvidia.nix
            ./modules/jellyfin.nix
            ./hosts/main
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
            {nixpkgs.overlays = [nur.overlays.default];}
          ];
        };
    };
  };
}
