{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  grep = "${pkgs.gnugrep}/bin/grep";
  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  niri = "${config.programs.niri.package}/bin/niri";
  pw-cli = "${pkgs.pipewire}/bin/pw-cli";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  cfg = config.custom.services.hypridle;
in {
  options.custom.services.hypridle = {
    enable = mkOption {default = false;};

    dpms = mkOption {
      default =
        if config.custom.desktop == "hyprland"
        then "${hyprctl} dispatch dpms off"
        else if config.custom.desktop == "niri"
        then "${niri} msg action power-off-monitors"
        else "";
    };
  };

  config.home-manager.users.${config.custom.username} = mkIf cfg.enable {
    # https://github.com/hyprwm/hypridle
    # https://wiki.hyprland.org/Hypr-Ecosystem/hypridle
    services.hypridle = {
      enable = true;

      settings.listener = [
        {
          timeout = 15 * 60; # Seconds
          on-timeout = cfg.dpms;
        }

        {
          timeout = 20 * 60; # Seconds
          on-timeout = "${loginctl} lock-session";
        }

        {
          timeout = 60 * 60; # Seconds
          on-timeout = "${pw-cli} info all | ${grep} running || ${systemctl} suspend-then-hibernate"; # Suspend if no audio
        }
      ];
    };

    # BUG: graphical-session-pre.target may not have WAYLAND_DISPLAY set, so service is skipped
    # https://github.com/nix-community/home-manager/issues/5899
    systemd.user.services.hypridle = {
      Unit = {
        After = mkForce ["graphical-session.target"]; # graphical-session-pre.target
      };
    };
  };
}
