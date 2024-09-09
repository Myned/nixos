{ config, lib, ... }:

with lib;

let
  cfg = config.custom.settings.environment;
in
{
  options.custom.settings.environment = {
    enable = mkOption { default = false; };
    builder = mkOption { default = config.custom.full; };
    timezone = mkOption { default = "America/Chicago"; };
    wayland = mkOption { default = config.custom.minimal; };
  };

  config = mkIf cfg.enable {
    time.timeZone = cfg.timezone;

    # https://wiki.nixos.org/wiki/Cross_Compiling
    boot.binfmt.emulatedSystems = mkIf cfg.builder [ "aarch64-linux" ]; # Emulate architecture
    #// nixpkgs.buildPlatform = "x86_64-linux"; # Binary caches often not available

    environment = {
      localBinInPath = true;

      # HACK: Nix does not currently handle locale properly, so force default
      # https://github.com/NixOS/nixpkgs/issues/183960 et al.
      #// i18n.defaultLocale = "C.UTF-8";

      sessionVariables = {
        GDK_SCALE = toString config.custom.scale; # Steam HiDPI

        # https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
        NIXOS_OZONE_WL = mkIf cfg.wayland "1";
      };

      shellAliases = {
        backup = "sudo borgmatic -v 1 create --progress --stats";
        extract = "sudo borgmatic -v 1 extract --progress";
        restore = "sudo borgmatic -v 1 restore";
        list = "sudo borgmatic -v 1 list";
        init = "sudo borgmatic init -e repokey-blake2";
        key = "sudo borgmatic key export";

        reboot = "sudo systemctl reboot";
        restart = "sudo systemctl reboot";
        poweroff = "sudo systemctl poweroff";
        shutdown = "sudo systemctl poweroff";

        rsync = "rsync --info=progress2";

        # https://github.com/aksiksi/compose2nix?tab=readme-ov-file#usage
        # https://github.com/aksiksi/compose2nix?tab=readme-ov-file#agenix
        compose2nix = concatStringsSep " " [
          "compose2nix"
          "--inputs compose.yaml"
          "--output compose.nix"
          "--root_path /containers"
          "--auto_format"
          "--check_systemd_mounts"
          "--env_files_only"
          "--ignore_missing_env_files"
          "--include_env_files"
          #?? --env_files /run/agenix/containers/*/.env
        ];
      };
    };
  };
}
