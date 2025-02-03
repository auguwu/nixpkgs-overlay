{
  description = "🐻‍❄️ Noel's `nixpkgs` overlay of packages and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    eachSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "x86_64-darwin"

      "aarch64-linux"
      "aarch64-darwin"
    ];

    nixpkgsFor = system:
      import nixpkgs {
        inherit system;
      };
  in {
    overlays.default = import ./overlay.nix;
    packages = eachSystem (system: (import ./overlay.nix {} (nixpkgsFor system)));
    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
