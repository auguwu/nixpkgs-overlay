{
  description = "🐻‍❄️ Noel's `nixpkgs` overlay of packages and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  # Include the binary caches for my own projects and Noelware's as well.
  nixConfig = {
    extra-substituters = [
      # TODO: switch to https://nix.floofy.dev
      "https://noel.cachix.org"
    ];

    extra-trusted-public-keys = [
      "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
    ];
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
    checks = eachSystem (system: let
      pkgs = import nixpkgs {
        inherit system;

        overlays = [(import ./overlay.nix)];
      };
    in
      import ./tests {inherit pkgs;});
  };
}
