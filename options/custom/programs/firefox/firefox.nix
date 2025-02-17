{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom.programs.firefox;
in {
  options.custom.programs.firefox = {
    enable = mkOption {default = false;};
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        # https://www.mozilla.org/en-US/firefox/developer
        programs.firefox = mkMerge [
          (import "${inputs.self}/modules/firefox.nix" {inherit config inputs lib pkgs;})

          {
            enable = true;
          }
        ];

        home.file = {
          ".mozilla/profiles.ini" = {
            force = true;
          };
        };
      }
    ];
  };
}
