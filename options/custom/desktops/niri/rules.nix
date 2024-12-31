{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.custom.desktops.niri.rules;
in {
  options.custom.desktops.niri.rules = {
    enable = mkOption {default = false;};
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.username} = {
      # https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules
      programs.niri.settings = {
        # HACK: Name workspaces after index to use open-on-workspace rule
        workspaces = {
          "1" = {};
          "2" = {};
          "3" = {};
        };

        window-rules = [
          ### Defaults

          {
            # Global
            geometry-corner-radius = let
              radius = config.custom.rounding + 0.0; # Convert to float
            in {
              top-left = radius;
              top-right = radius;
              bottom-right = radius;
              bottom-left = radius;
            };

            clip-to-geometry = true;
          }

          {
            # Startup
            #?? <= 60 secs after niri launches
            matches = [{at-startup = true;}];
          }

          {
            # Android
            matches = [{app-id = "^[Ww]aydroid.*$";}];
          }

          {
            # Browsers
            matches = [
              {app-id = "^brave-browser$";}
              {app-id = "^chromium-browser$";}
              {app-id = "^firefox.*$";}
              {app-id = "^google-chrome$";}
              {app-id = "^vivaldi.*$";}
            ];

            open-on-workspace = "2";
          }

          {
            # Chats
            matches = [
              {app-id = "^cinny$";}
              {app-id = "^discord$";}
              {app-id = "^Element$";}
              {app-id = "^org\.telegram\.desktop$";}
            ];
          }

          {
            # Dropdown terminal
            matches = [{app-id = "^dropdown$";}];
          }

          {
            # Editors
            matches = [
              {app-id = "^codium$";}
              {app-id = "^obsidian$";}
            ];

            open-on-workspace = "2";
          }

          {
            # Files
            matches = [{app-id = "^org\.gnome\.Nautilus$";}];
          }

          {
            # Games
            matches = [
              {app-id = "^.*\.(exe|x86_64)$";}
                {app-id = "^love$";} # vrrtest
                {app-id = "^moe\.launcher\..+$";} # Anime Game Launcher
              {app-id = "^net\.retrodeck\.retrodeck$";}
              {app-id = "^steam_app_.+$";}
            ];

            open-on-workspace = "1";
            variable-refresh-rate = true;
          }

          {
            # Media
            matches = [
              {app-id = "^org\.gnome\.Loupe$";}
              {app-id = "^Spotify$";}
              {app-id = "^totem$";}
              {app-id = "^YouTube Music$";}
            ];

            open-on-workspace = "3";
          }

          {
            # Office
            matches = [
              {app-id = "^draw\.io$";}
              {app-id = "^libreoffice$";}
              {app-id = "^ONLYOFFICE Desktop Editors$";}
            ];

            open-on-workspace = "2";
          }

          {
            # PiP
            matches = [{title = "^Picture.in.[Pp]icture$";}];
          }

          {
            # Terminals
            matches = [
              {app-id = "^foot$";}
              {app-id = "^kitty$";}
              {app-id = "^org\.wezfurlong\.wezterm$";}
            ];
          }

          {
            # Vaults
            matches = [
              {app-id = "^1Password$";}
              {app-id = "^Bitwarden$";}
            ];
          }

          {
            # Virtual machines
            matches = [
              {app-id = "^(sdl-|wl|x)freerdp$";}
              {app-id = "^looking-glass-client$";}
              {app-id = "^org\.remmina\.Remmina$";}
              {app-id = "^virt-manager$";}
            ];

            open-on-workspace = "1";
          }

          ### Overrides
        ];
      };
    };
  };
}
