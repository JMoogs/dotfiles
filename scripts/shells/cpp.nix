{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # llvmPackages_9.clang-unwrapped    
    clang-tools
  ];
}
