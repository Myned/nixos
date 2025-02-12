{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom;
in {
  options.custom = {
    ### Profiles
    default = mkOption {default = true;};
    full = mkOption {default = false;};
    minimal = mkOption {default = cfg.full;};
    profile = mkOption {};

    ### Users
    domain = mkOption {default = "bjork.tech";};
    hostname = mkOption {};
    realname = mkOption {default = "Myned";};
    username = mkOption {default = "myned";};
    sync = mkOption {default = "/home/myned/SYNC";};

    ### Hardware
    width = mkOption {default = 1920;};
    height = mkOption {default = 1080;};
    refresh = mkOption {default = 60;};
    vrr = mkOption {default = false;};
    ultrawide = mkOption {default = cfg.width * 9 / 16 > cfg.height;}; # Wider than 16:9
    hidpi = mkOption {default = cfg.scale > 1;};
    scale = mkOption {default = 1;};
    border = mkOption {default = 2;};
    gap = mkOption {default = 20;};
    padding = mkOption {default = 51;}; # ?? journalctl --user -u waybar.service | grep height:
    rounding = mkOption {default = 15;};

    ### Misc
    desktop = mkOption {
      default =
        if config.custom.full
        then "niri"
        else "gnome";
    };

    lockscreen = mkOption {default = "hyprlock";};
    menu = mkOption {default = "rofi";};
    wallpaper = mkOption {default = false;};

    browser = {
      # TODO: Use lib.getExe' instead of /bin/ where possible
      # HACK: Find first matching package in final home-manager list
      command = mkOption {
        default = "${lib.findFirst (pkg:
            if (lib.hasAttr "pname" pkg)
            then pkg.pname == "brave"
            else false)
          null
          config.home-manager.users.${config.custom.username}.home.packages}/bin/brave";
      };

      desktop = mkOption {default = "brave.desktop";};
      package = mkOption {default = pkgs.brave;};
    };
  };
}
