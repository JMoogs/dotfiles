{
  description = "My Nix/NixOS config";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ...} @ inputs : {

    nixosConfigurations = {
      "Jeremy-nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;
            userOptions = {
              nvidia = true;
              hostname = "Jeremy-nixos";
              username = "jeremy";
              wm = "i3";
              device = "pc";
            };
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jeremy = import ./home.nix;
              home-manager.extraSpecialArgs = {
                userOptions = {
                  nvidia = true;
                  hostname = "Jeremy-nixos";
                  username = "jeremy";
                  wm = "i3";
                  device = "pc";
                };
              };
            }
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };     

      "Jeremy-pc-plasma" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;
            userOptions = {
              nvidia = true;
              hostname = "Jeremy-nixos";
              username = "jeremy";
              wm = "plasma";
              device = "pc";
            };
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jeremy = import ./home.nix;
              home-manager.extraSpecialArgs = {
                userOptions = {
                  nvidia = true;
                  hostname = "Jeremy-nixos";
                  username = "jeremy";
                  wm = "plasma";
                  device = "pc";
                };
              };
            }
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };

      
    };
  };
}
