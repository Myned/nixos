{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  gamescope = "${config.programs.gamescope.package}/bin/gamescope";
  kitty = "${config.home-manager.users.${config.custom.username}.programs.kitty.package}/bin/kitty";
  libreoffice = "${config.custom.programs.libreoffice.package}/bin/libreoffice";
  loupe = "${pkgs.loupe}/bin/loupe";
  pgrep = "${pkgs.procps}/bin/pgrep";
  steam = "${config.programs.steam.package}/bin/steam";
  virt-manager = "${pkgs.virt-manager}/bin/virt-manager";
  waydroid = "${pkgs.waydroid}/bin/waydroid";
  youtube-music = "${pkgs.youtube-music}/bin/youtube-music";

  cfg = config.custom.desktops.hyprland.rules;
in {
  options.custom.desktops.hyprland.rules.enable = mkOption {default = false;};

  config.home-manager.users.${config.custom.username} = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      # https://wiki.hyprland.org/Configuring/Workspace-Rules
      #?? workspace = WORKSPACE, RULES
      workspace = [
        "name:gamescope, on-created-empty:MANGOHUD=0 ${gamescope} --fullscreen --steam ${steam}"

        "special:android, on-created-empty:${waydroid} app launch com.YoStarEN.Arknights"
        "special:music, on-created-empty:${youtube-music}"
        "special:office, on-created-empty:${libreoffice}"
        "special:steam, on-created-empty:${steam}"
        "special:terminal, on-created-empty:${kitty}"
        "special:vm, on-created-empty:${pgrep} -x vm || ${virt-manager}"
        "special:wallpaper, on-created-empty:[tile] ${loupe} /tmp/wallpaper.png"
      ];

      # https://wiki.hyprland.org/Configuring/Window-Rules
      #?? windowrulev2 = RULE, WINDOW
      windowrulev2 = with config.custom; let
        ### Hardware-dependent rules
        # Convert truncated float to string
        tr = num: toString (builtins.floor num);

        # Bottom center
        clipboard = rec {
          x = tr (width / scale / 2 - (toInt w) / 2);
          y = tr (height / scale - (toInt h) - gap - border - padding);
          w = "600";
          h = tr (height / scale * 0.5 * scale);
        };

        # Bottom center
        dropdown = rec {
          x = tr (width / scale / 2 - (toInt w) / 2);
          y = tr (height / scale - (toInt h) - gap - border - padding);
          w = tr (width
            / scale
            * (
              if ultrawide
              then 0.5
              else 1
            )
            - gap
            - gap / 2
            + 1);
          h = tr (height / scale * 0.2 * scale);
        };

        # Top right
        pip = rec {
          x = tr (width / scale - (toInt w) - gap - border);
          y = tr (gap + border);
          w = tr (width / scale * 0.25 - gap - gap + 1);
          h = tr ((toInt w) * 9 / 16); # 16:9 aspect ratio
        };

        ### Rules
        # Return hypr-formatted string, converting booleans into 0/1
        format = field: expr: "${field}:${
          toString (
            if expr == true
            then 1
            else if expr == false
            then 0
            else expr
          )
        }";

        # Generate hypr-formatted window rules
        #?? merge <FIELD|{FIELDS}> <EXPRESSION> <RULES>
        merge = field: expr: rules:
          map (
            rule:
              if builtins.isAttrs field
              then "${rule}, ${lib.concatStringsSep ", " (lib.mapAttrsToList (f: e: format f e) field)}"
              else "${rule}, ${format field expr}"
          )
          rules;

        class = expr: rules: merge "class" "^${expr}$" rules;
        floating = expr: rules: merge "floating" expr rules;
        fullscreen = expr: rules: merge "fullscreen" expr rules;
        pinned = expr: rules: merge "pinned" expr rules;
        title = expr: rules: merge "title" "^${expr}$" rules;

        fields = fields: rules: merge fields null rules;

        ### Pseudo-tags
        # Wrap generated rules in Nix categories
        tag = {
          android = rules: [
            (class "waydroid.*" rules)
          ];
          clipboard = rules: [
            (class "clipboard" rules)
          ];
          dropdown = rules: [
            (class "dropdown" rules)
          ];
          editor = rules: [
            (class "codium-url-handler" rules) # VSCode
            (class "obsidian" (rules ++ ["group barred"]))
          ];
          files = rules: [
            (class "org\\.gnome\\.Nautilus" rules)
          ];
          game = rules: [
            (class "moe\\.launcher\\.the-honkers-railway-launcher" (rules ++ ["size 1280 730"])) # Honkai: Star Rail
            (class "steam_app_.+" rules) # Proton
          ];
          music = rules: [
            (class "Spotify" rules)
            (class "YouTube Music" rules)
            (title "Spotify Premium" rules)
          ];
          office = rules: [
            (class "libreoffice.+" rules)
          ];
          pip = rules: [
            (title "Picture.in.[Pp]icture" rules)
          ];
          social = rules: [
            (class "cinny" rules)
            (class "discord" rules)
            (class "Element" rules)
            (class "org\\.telegram\\.desktop" rules)
          ];
          steam = rules: [
            (class "SDL Application" rules) # Steam
            (class "steam" rules)
          ];
          terminal = rules: [
            (class "foot" rules)
            (class "kitty" rules)
            (class "org\\.wezfurlong\\.wezterm" rules)
          ];
          vm = rules: [
            (class "(sdl-|wl|x)freerdp" (rules ++ ["nomaxsize" "tile"]))
            (class "virt-manager" rules)
          ];
          wine = rules: [
            (class ".*\\.(exe|x86_64)" rules) # Wine
          ];
        };
      in
        flatten [
          ### Defaults
          (class ".*" ["float" "suppressevent maximize" "syncfullscreen"])
          (floating false ["noshadow"])
          (floating true ["bordercolor rgb(073642)"])
          (fullscreen true ["idleinhibit focus"])
          (pinned true ["bordercolor rgb(073642) rgb(073642)"])

          (tag.android ["tile" "workspace special:android"])
          (tag.clipboard ["move ${clipboard.x} ${clipboard.y}" "pin" "size ${clipboard.w} ${clipboard.h}" "stayfocused"])
          (tag.dropdown ["move ${dropdown.x} ${dropdown.y}" "pin" "size ${dropdown.w} ${dropdown.h}"])
          (tag.editor ["group invade" "tile"])
          (tag.files ["size 1000 625"])
          (tag.game ["fullscreen" "group barred" "idleinhibit always" "noborder" "noshadow" "renderunfocused" "workspace name:game"])
          (tag.music ["tile" "workspace special:music"])
          (tag.office ["tile" "workspace special:office"])
          (tag.pip ["keepaspectratio" "move ${pip.x} ${pip.y}" "pin" "size ${pip.w} ${pip.h}"])
          (tag.social ["group" "tile"])
          (tag.steam ["workspace special:steam"])
          (tag.terminal ["tile"])
          (tag.vm ["workspace special:vm"])
          (tag.wine ["noborder" "noshadow"])

          ### Overrides
          (class "steam_app_1473350" ["workspace 0"]) # (the) Gnorp Apologue
          (class "Tap Wizard 2.x86_64" ["workspace 0"])

          #!! Expressions are not wrapped in ^$
          (fields {
            class = "^com\\.github\\.wwmm\\.easyeffects$";
            title = "^Easy Effects$"; # Main window
          } ["size 50% 50%"])
          (fields {
            class = "^discord$";
            title = "^Discord Updater$"; # Update dialog
          } ["float" "nofocus"])
          (fields {
            class = "^lutris$";
            title = "^Lutris$"; # Main window
          } ["center" "size 1000 500"])
          (fields {
            class = "^steam$";
            title = "^notificationtoasts$"; # Steam notifications
          } [])
          (fields {
            class = "^steam$";
            title = "^Steam$"; # Main window
          } ["tile"])
          (fields {
            class = "^virt-manager$";
            title = "^.+on QEMU/KVM$"; # VM window
          } ["tile"])
        ];
    };
  };
}
