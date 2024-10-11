{ config, lib, ... }:
let
  cfg = config.playerConfig;
in
{
  options.playerConfig = {
    sshKey = lib.mkOption {
      type = lib.types.str;
      description = "The ssh public key to add to the `me` authorized keys";
    };

    webserver = lib.mkOption {
      type = lib.types.package;
      description = "The webserver package to run";
    };
  };

  config = {
    systemd.services.webserver = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "The player webserver service";
      script = lib.getExe cfg.webserver;
      environment = {
        PORT = "8080";
      };
      serviceConfig.DynamicUser = true;
    };

    services.nginx = {
      enable = true;
      virtualHosts = {
        "default" = {
          default = true;
          locations."/".proxyPass = "http://127.0.0.1:8080";
        };
      };
    };

    users.users.me = {
      isNormalUser = true;
      description = "me";
      extraGroups = [
        "wheel"
        "systemd-journal"
      ];
      openssh.authorizedKeys.keys = [ cfg.sshKey ];
    };

    garnix.server.enable = true;

    services.openssh.enable = true;

    security.sudo = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };

    networking = {
      hostName = "player";
      firewall.allowedTCPPorts = [ 80 ];
    };

    virtualisation.vmVariant.services.getty.autologinUser = "me";
    system.stateVersion = "24.11";
  };
}
