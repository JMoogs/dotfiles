{pkgs ? import <nixpkgs> {}}: let
  my-python-packages = ps:
    with ps; [
      matplotlib
      networkx
      python-lsp-server
      scipy
      # numpy
      # pygame
      # pandas
      # requests
      # other python packages
    ];
  my-python = pkgs.python3.withPackages my-python-packages;
in
  my-python.env
