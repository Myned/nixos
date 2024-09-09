{
  config,
  inputs,
  lib,
  ...
}:

with lib;

let
  cfg = config.custom.settings.containers.foundryvtt;
in
{
  options.custom.settings.containers.foundryvtt.enable = mkOption { default = false; };

  config = mkIf cfg.enable {
    age.secrets =
      let
        secret = filename: {
          file = "${inputs.self}/secrets/${filename}";
        };
      in
      {
        "${config.custom.profile}/foundryvtt/.env" = secret "${config.custom.profile}/foundryvtt/.env";
      };

    #?? arion-foundryvtt pull
    environment.shellAliases.arion-foundryvtt = "sudo arion --prebuilt-file ${config.virtualisation.arion.projects.foundryvtt.settings.out.dockerComposeYaml}";

    virtualisation.arion.projects.foundryvtt = {
      serviceName = "foundryvtt";

      settings.services = {
        foundryvtt.service = {
          container_name = "foundryvtt";
          env_file = [ config.age.secrets."${config.custom.profile}/foundryvtt/.env".path ];
          image = "felddy/foundryvtt:12";
          ports = [ "127.0.0.1:30000:30000" ];
          restart = "unless-stopped";
          volumes = [ "${config.custom.settings.containers.directory}/foundryvtt/data:/data" ];
        };
      };
    };
  };
}
