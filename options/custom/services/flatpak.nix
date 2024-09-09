{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.custom.services.flatpak;
in
{
  options.custom.services.flatpak.enable = mkOption { default = false; };

  config = mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/Flatpak
    # https://github.com/gmodena/nix-flatpak
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true; # Immutable flatpaks
      update.auto.enable = true; # Auto update flatpaks weekly

      #!! Installation occurs in background as a oneshot service
      #?? flatpak search NAME
      packages = [
        "app.drey.Biblioteca"
        "com.github.tchx84.Flatseal"
      ];
    };

    # Theme packages must be installed system-wide for flatpaks
    environment.systemPackages = with pkgs; [
      adw-gtk3
      google-cursor
      papirus-icon-theme
    ];
  };
}
