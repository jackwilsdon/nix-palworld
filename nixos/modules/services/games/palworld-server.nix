{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.palworld-server = {
    enable = lib.mkEnableOption "the Palworld server";
    package = lib.mkPackageOption pkgs "palworld-server" { };
    dataDir = lib.mkOption {
      description = "The directory to store Palworld data in.";
      type = lib.types.path;
    };
    port = lib.mkOption {
      description = "Port to listen on.";
      type = lib.types.port;
      default = 8211;
    };
    openFirewall = lib.mkOption {
      default = false;
      description = "Open the configured port in the firewall.";
      type = lib.types.bool;
    };
    user = lib.mkOption {
      default = "palworld";
      description = "User to run Palworld under.";
      type = lib.types.str;
    };
    group = lib.mkOption {
      default = "palworld";
      description = "Group to run Palworld under.";
      type = lib.types.str;
    };
  };
  config = lib.mkIf config.services.palworld-server.enable {
    networking.firewall.allowedUDPPorts = lib.optionals config.services.palworld-server.openFirewall [
      config.services.palworld-server.port
    ];
    systemd.services.palworld-server = {
      after = [ "network.target" ];
      description = "Palworld Server Service";
      serviceConfig = {
        ExecStart = "${lib.getExe config.services.palworld-server.package} -port=${builtins.toString config.services.palworld-server.port} -UserDir=${config.services.palworld-server.dataDir}";
        Group = config.services.palworld-server.group;
        User = config.services.palworld-server.user;
      };
      wantedBy = [ "multi-user.target" ];
    };
    users = {
      groups.palworld = lib.mkIf (config.services.palworld-server.group == "palworld") { };
      users.palworld = lib.mkIf (config.services.palworld-server.user == "palworld") {
        description = "Palworld server user";
        group = config.services.palworld-server.group;
        isSystemUser = true;
      };
    };
  };
}
