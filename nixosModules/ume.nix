{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf;

  cfg = config.services.ume;
  format = pkgs.formats.toml {};
in {
  options.services.ume = with lib.types; {
    enable = mkEnableOption "ume";
    package = mkPackageOption pkgs "ume" {};

    user = mkOption {
      type = str;
      default = "ume";
      description = "`ume` user account";
    };

    group = mkOption {
      type = str;
      default = "ume";
      description = "`ume` group account";
    };

    stateDir = mkOption {
      type = str;
      default = "/var/lib/noel/ume";
      description = "Directory to hold state data in";
    };

    configuration = {
      inherit (format) type;

      description = "Attribute set for the `ume.toml` configuration file";
      default = {};
      example = {
        uploader_key = "<random string>";
        server = {
          host = "0.0.0.0";
          port = 3100;
        };
      };
    };

    environment = mkOption {
      type = attrsOf str;
      description = "A list of extra environment variables to set";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "`ume` user account";
      group = cfg.group;
    };

    users.groups.${cfg.group} = {};
    systemd.services.ume = {
      description = "ume :: Image Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      preStart = ''
        ## Generate the `ume.toml` file if it doesn't exist
        if ! [ -f "${cfg.stateDir}/ume.toml" ]; then
          echo -e "\n${format.generate "ume.toml" cfg.configuration}"
            >> "${cfg.stateDir}/ume.toml"
        fi
      '';

      environment = cfg.environment;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "oneshot";

        StateDirectory = cfg.stateDir;
        StateDirectoryMode = 0700;

        ExecStart = "${cfg.package}/bin/ume server --config=${cfg.stateDir}/ume.toml";
        RemainAfterExit = true;
      };
    };
  };
}
