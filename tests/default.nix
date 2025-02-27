{pkgs}: let
  inherit (builtins) map replaceStrings listToAttrs;
  inherit (pkgs) testers;

  tests = [
    "modules/ume/server"
  ];
in
  listToAttrs (map (test: {
      name = replaceStrings ["/"] ["-"] test;
      value = testers.runNixOSTest ./${test};
    })
    tests)
