{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom.settings.fonts;
  hm = config.home-manager.users.${config.custom.username};

  rsync = getExe pkgs.rsync;
in {
  options.custom.settings.fonts = {
    enable = mkOption {default = false;};
    emoji = mkOption {default = "Blobmoji";};
    fallback = mkOption {default = "Unifont";};
    monospace = mkOption {default = "IosevkaTermSlab NFP Medium";};
    sans-serif = mkOption {default = "Arvo";};
    serif = mkOption {default = "Lora";};
    weight = mkOption {default = "400";};
  };

  config = mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/Fonts
    fonts = {
      # BUG: Amount of installed fonts impacts pango load times, so only install necessary fonts
      # https://github.com/davatorium/rofi/issues/673 et al.
      packages = with pkgs.nerd-fonts;
        [
          # https://www.nerdfonts.com/#home
          # Monospace
          #// departure-mono
          #// gohufont
          #// iosevka-term
          iosevka-term-slab
          #// jetbrains-mono
          #// roboto-mono
          #// shure-tech-mono
          #// space-mono
          #// zed-mono
        ]
        ++ (with pkgs; [
          # https://fonts.google.com/
          (google-fonts.override {
            fonts = [
              # Pixel
              #// "Geo"
              #// "Silkscreen"

              # Sans-serif
              #// "Josefin Sans"
              #// "Jost"
              #// "Lexend"
              #// "Outfit"
              #// "Roboto"
              #// "Roboto Flex"

              # Sans-serif condensed
              #// "Oswald"
              #// "Roboto Condensed"

              # Serif
              "Lora"
              #// "Roboto Serif"

              # Slab
              #// "Aleo"
              "Arvo"
              #// "Josefin Slab"
              #// "Roboto Slab"
              #// "Solway"
            ];
          })

          # Emoji
          #// noto-fonts-color-emoji
          noto-fonts-emoji-blob-bin

          # Microsoft
          vista-fonts

          # Fallback
          unifont
        ]);

      #?? fc-list : family | sort
      fontconfig.defaultFonts = {
        emoji = [cfg.emoji];
        monospace = [cfg.monospace];
        sansSerif = [cfg.sans-serif];
        serif = [cfg.serif];
      };
    };

    home-manager.sharedModules = [
      {
        # Inherit from system module
        fonts.fontconfig.defaultFonts = config.fonts.fontconfig.defaultFonts;

        # HACK: Some applications do not support fontconfig nor symlinks, so copy fonts to user directory
        # https://github.com/ONLYOFFICE/DocumentServer/issues/1859 et al.
        home.activation = {
          # BUG: rsync sets directory permissions too early
          # https://github.com/RsyncProject/rsync/issues/609
          copy-fonts = hm.lib.dag.entryAfter ["writeBoundary"] ''
            run ${rsync} --recursive --copy-links --times \
              /run/current-system/sw/share/fonts "$XDG_DATA_HOME/"
          '';
        };
      }
    ];
  };
}
