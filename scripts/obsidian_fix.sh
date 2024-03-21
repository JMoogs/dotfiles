#!/usr/bin/env bash

export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
