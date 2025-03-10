#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-output-monitor

# This will run `nix flake check`, which runs all NixOS module tests.

set -euo pipefail

nix flake check --show-trace --log-format internal-json 2>&1 |& nom --json
