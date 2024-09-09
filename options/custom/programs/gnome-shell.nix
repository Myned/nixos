{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.custom.programs.gnome-shell;
in
{
  options.custom.programs.gnome-shell.enable = mkOption { default = false; };

  config.home-manager.users.${config.custom.username} = mkIf cfg.enable {
    # BUG: programs.gnome-shell.theme option forces installation of gnome-shell-extensions
    programs.gnome-shell = {
      enable = true;

      extensions =
        with pkgs.gnomeExtensions;
        optionals config.custom.default [
          { package = appindicator; } # https://github.com/ubuntu/gnome-shell-extension-appindicator

        ]
        ++ optionals config.custom.minimal [
          { package = caffeine; } # https://github.com/eonpatapon/gnome-shell-extension-caffeine
          { package = dash-to-dock; } # https://github.com/micheleg/dash-to-dock
          #// { package = dash2dock-lite; } # https://github.com/icedman/dash2dock-lite
          { package = gsconnect; } # https://github.com/GSConnect/gnome-shell-extension-gsconnect
          { package = just-perfection; } # https://gitlab.gnome.org/jrahmatzadeh/just-perfection
          #// { package = user-themes; } # https://gitlab.gnome.org/GNOME/gnome-shell-extensions

        ]
        ++ optionals config.custom.full [
          #// { package = auto-move-windows; } # https://gitlab.gnome.org/GNOME/gnome-shell-extensions
          { package = clipboard-indicator; } # https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator
          { package = ddterm; } # https://github.com/ddterm/gnome-shell-extension-ddterm
          #// { package = hide-top-bar; } # https://gitlab.gnome.org/tuxor1337/hidetopbar
          { package = media-controls; } # https://github.com/sakithb/media-controls
          #// { package = smart-auto-move; } # https://github.com/khimaros/smart-auto-move
          { package = tailscale-qs; } # https://github.com/joaophi/tailscale-gnome-qs
          { package = tiling-assistant; } # https://github.com/Leleat/Tiling-Assistant
        ];
    };

    #!! Installed to user directory until packaged into nixpkgs
    # https://github.com/flexagoon/rounded-window-corners
    # TODO: Use extension store version when published
    # https://extensions.gnome.org/review/55303
    home.file.".local/share/gnome-shell/extensions/rounded-window-corners@fxgn".source =
      mkIf config.custom.full pkgs.fetchzip
        {
          stripRoot = false;
          url = "https://extensions.gnome.org/review/download/55303.shell-extension.zip";
          sha256 = "sha256-cg4/Y0irl5X2D2P/ncYJM0fRbeAgRSfBXmdRoVBY7jo=";
        };
  };
}
