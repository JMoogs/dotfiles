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

    # Aylurs GTK shell, for widgets: https://aylur.github.io/ags-docs/
    ags.url = "github:Aylur/ags";

    # Use hyprland (WM) from master
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix version of neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "Jeremy-nixos" = let
        opts = {
          nvidia = true;
          hostname = "Jeremy-nixos";
          username = "jeremy";
          device = "pc";
          theme = "frappe";
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

      "Jeremy-laptop" = let
        opts = {
          nvidia = false;
          hostname = "Jeremy-nixos-laptop";
          username = "jeremy";
          device = "laptop";
          theme = "frappe";
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
    };
  };
}
