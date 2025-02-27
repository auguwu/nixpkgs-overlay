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

    configuration = mkOption {
      inherit (format) type;

      default = {
        "storage.filesystem".directory = cfg.stateDir;
      };

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
      isSystemUser = true;
    };

    environment.etc."noel/ume/config.toml".source = format.generate "ume.toml" cfg.configuration;

    users.groups.${cfg.group} = {};
    systemd.services.ume = {
      description = "ume :: Image Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      environment =
        {
          UME_CONFIG_FILE = "/etc/noel/ume/config.toml";
        }
        // cfg.environment;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "oneshot";

        StateDirectory = cfg.stateDir;
        StateDirectoryMode = 0700;

        ExecStart = "${cfg.package}/bin/ume server";
        RemainAfterExit = true;
      };
    };
  };
}
