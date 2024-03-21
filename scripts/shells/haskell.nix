{ nixpkgs ? import <nixpkgs> {} }:

let
  inherit (nixpkgs) pkgs;
in

pkgs.mkShell {
  buildInputs = [
    (pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [
      random
    ]))
  ];
}
