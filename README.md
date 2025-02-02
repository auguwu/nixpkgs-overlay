# :polar_bear: `noel/nixpkgs`
This repository contains a Nix overlay that can be applied to `nixpkgs` to include:

- Universal builds and NixOS modules for my projects and services.

<!-- Every package is cached at [`nix.floofy.dev`](https://nix.floofy.dev), so you can add this to your Nix configuration in `flake.nix` to use the cached version instead of building it yourself:

```nix
{
    nixConfig = {
        extra-substituters = ["https://nix.floofy.dev"];
        extra-trusted-public-keys = [ "TODO: this" ];
    };
}
```
-->

## Usage
```nix
{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        noel = {
            url = "github:auguwu/nixpkgs-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, noel-overlay, ... }: let
        overlays = [(import noel)];
        system = "x86_64-linux";

        pkgs = import nixpkgs {
            inherit overlays system;
        };
    in {
        # do whatever with `pkgs` or modify
        # this to your liking
    };
}
```

## License
The code for the services and packages are released under [Unlicense]. You can freely copy and use the code if you want, I don't really care.

[Unlicense]: https://unlicense.org/
