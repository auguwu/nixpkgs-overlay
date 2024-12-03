{
  description = "🐻‍❄️ Noel's `nixpkgs` overlay of packages and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    systems,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    nixpkgsFor = system:
      import nixpkgs {
        inherit system;
      };
  in {
    overlays.default = import ./overlay.nix;
    packages = eachSystem (system: let
      pkgs = nixpkgsFor system;
    in {
      ume = pkgs.callPackage ./packages/ume {};
    });

    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
