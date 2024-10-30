{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  nautilus = "${pkgs.nautilus}/bin/nautilus";

  cfg = config.custom.programs.nautilus;
in {
  options.custom.programs.nautilus.enable = mkOption {default = false;};

  config = mkIf cfg.enable {
    # TODO: Use module when completed
    # https://github.com/NixOS/nixpkgs/pull/319535
    environment.systemPackages = [pkgs.nautilus];

    services = {
      gvfs.enable = true; # Trash dependency

      gnome = {
        sushi.enable = true; # Quick preview with spacebar
        #// tracker.enable = true; # File indexing
        #// tracker-miners.enable = true;
      };
    };

    # Alternative fix to services.gnome.core-utilities.enable
    # https://github.com/NixOS/nixpkgs/pull/240780
    #?? echo $NAUTILUS_4_EXTENSION_DIR
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

    home-manager.users.${config.custom.username} = {
      # HACK: Partially fix startup delay with background service until module is available
      systemd.user.services = {
        nautilus = {
          Unit.Description = "GNOME Files Background Service";
          Install.WantedBy = ["graphical-session.target"];

          Service = {
            BusName = "org.gnome.Nautilus";
            ExecStart = "${nautilus} --gapplication-service";
            ExecStop = "${nautilus} --quit";
            Restart = "on-failure";
            Type = "dbus";
          };
        };
      };
    };
  };
}
