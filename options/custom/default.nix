{
  config,
  lib,
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

    ### Hardware
    width = mkOption {default = 1920;};
    height = mkOption {default = 1080;};
    ultrawide = mkOption {default = cfg.width * 9 / 16 > cfg.height;}; # Wider than 16:9
    hidpi = mkOption {default = cfg.scale > 1;};
    scale = mkOption {default = 1;};

    # TODO: Use option for border size
    border = mkOption {default = 2;};

    gap = mkOption {default = 10;};
    padding = mkOption {default = 56;}; # ?? journalctl --user -u waybar.service | grep height:

    ### Misc
    wallpaper = mkOption {default = false;};

    font = {
      emoji = mkOption {default = "Noto Color Emoji";};
      monospace = mkOption {default = "Iosevka NFP SemiBold";};
      sans-serif = mkOption {default = "Outfit";};
      serif = mkOption {default = "Liberation Serif";};
    };
  };
}
