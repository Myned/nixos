{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  audio = "~/.local/bin/audio";
  cat = "${pkgs.coreutils}/bin/cat";
  clipse = "${pkgs.clipse}/bin/clipse";
  codium = "${config.home-manager.users.${config.custom.username}.programs.vscode.package}/bin/codium";
  gnome-text-editor = "${pkgs.gnome-text-editor}/bin/gnome-text-editor";
  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";
  hyprlock = "${config.home-manager.users.${config.custom.username}.programs.hyprlock.package}/bin/hyprlock";
  hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
  inhibit = config.home-manager.users.${config.custom.username}.home.file.".local/bin/inhibit".source;
  jq = "${pkgs.jq}/bin/jq";
  kill = "${pkgs.procps}/bin/kill";
  kitty = "${config.home-manager.users.${config.custom.username}.programs.kitty.package}/bin/kitty";
  left = config.home-manager.users.${config.custom.username}.home.file.".local/bin/left".source;
  libreoffice = "${config.custom.programs.libreoffice.package}/bin/libreoffice";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  menu = config.home-manager.users.${config.custom.username}.home.file.".local/bin/menu".source;
  nautilus = "${pkgs.nautilus}/bin/nautilus";
  networkmanager_dmenu = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  obsidian = "${pkgs.obsidian}/bin/obsidian";
  onlyoffice-desktopeditors = "${pkgs.onlyoffice-bin}/bin/onlyoffice-desktopeditors --system-title-bar --xdg-desktop-portal";
  pkill = "${pkgs.procps}/bin/pkill";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  power = config.home-manager.users.${config.custom.username}.home.file.".local/bin/power".source;
  remote = config.home-manager.users.${config.custom.username}.home.file.".local/bin/remote".source;
  rofi-rbw = "${pkgs.rofi-rbw}/bin/rofi-rbw";
  rm = "${pkgs.coreutils}/bin/rm";
  screenshot = "~/.local/bin/screenshot";
  sleep = "${pkgs.coreutils}/bin/sleep";
  smile = "${pkgs.smile}/bin/smile";
  steam = "${config.programs.steam.package}/bin/steam";
  swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  toggle = "~/.local/bin/toggle";
  virt-manager = "${config.programs.virt-manager.package}/bin/virt-manager";
  vrr = config.home-manager.users.${config.custom.username}.home.file.".local/bin/vrr".source;
  walker = "${config.home-manager.users.${config.custom.username}.programs.walker.package}/bin/walker";
  waydroid = "${pkgs.waydroid}/bin/waydroid";
  window = config.home-manager.users.${config.custom.username}.home.file.".local/bin/window".source;
  workspace = config.home-manager.users.${config.custom.username}.home.file.".local/bin/workspace".source;
  zoom = config.home-manager.users.${config.custom.username}.home.file.".local/bin/zoom".source;

  cfg = config.custom.desktops.hyprland.binds;
in {
  options.custom.desktops.hyprland.binds.enable = mkOption {default = false;};

  config = mkIf cfg.enable {
    home-manager.users.${config.custom.username} = {
      wayland.windowManager.hyprland.settings = let
        # Reverse mods and key for alphabetical sorting
        #?? key <"KEY"> <"MODS"|null> <"DISPATCHER"> <"PARAMS"|null>
        key = key: mods: dispatcher: params: "${
          if (isNull mods)
          then ""
          else mods
        }, ${key}, ${dispatcher}${
          if (isNull params)
          then ""
          else ", ${params}"
        }";
      in {
        # https://wiki.hyprland.org/Configuring/Binds
        #?? bind = MODS, KEY, DISPATCHER, [PARAMS]
        #?? wev

        # Lockscreen binds
        bindl = [
          (key "Delete" "Ctrl" "exec" "${hyprctl} reload")
          (key "Delete" "Ctrl+Alt" "exec" "${loginctl} terminate-user ''") # Current user sessions
          (key "Delete" "Super" "exec" inhibit)

          (key "L" "Super" "exec" "${hyprlock} --immediate & ${sleep} 1 && ${hyprctl} dispatch dpms off")

          # Laptop lid switches
          # https://wiki.hyprland.org/Configuring/Binds/#switches
          #?? hyprctl devices
          #// (key "switch:off:Lid Switch" null "dpms" "on") # Open
          #// (key "switch:on:Lid Switch" null "dpms" "off") # Close
        ];

        # Mouse binds
        bindm = [
          (key "mouse:272" "Super" "movewindow" null) # LMB
          (key "mouse:273" "Super" "resizewindow" null) # RMB
        ];

        # Repeat binds
        binde = [
          # Media keys
          # https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
          (key "XF86AudioMute" null "exec" "${swayosd-client} --output-volume mute-toggle") # F1
          (key "XF86AudioLowerVolume" null "exec" "${swayosd-client} --output-volume lower") # F2
          (key "XF86AudioRaiseVolume" null "exec" "${swayosd-client} --output-volume raise") # F3
          (key "XF86AudioPrev" null "exec" "${playerctl} previous") # F4
          (key "XF86AudioPlay" null "exec" "${playerctl} play-pause") # F5
          (key "XF86AudioNext" null "exec" "${playerctl} next") # F6
          (key "XF86MonBrightnessDown" null "exec" "${swayosd-client} --brightness lower") # F7
          (key "XF86MonBrightnessUp" null "exec" "${swayosd-client} --brightness raise") # F8
          (key "XF86AudioMedia" null "exec" "${notify-send} test") # F12

          (key "0" "Super" "exec" "${swayosd-client} --output-volume mute-toggle")
          (key "Minus" "Super" "exec" "${swayosd-client} --output-volume lower")
          (key "Equal" "Super" "exec" "${swayosd-client} --output-volume raise")
          (key "Left" "Super" "exec" "${playerctl} previous")
          (key "Space" "Super" "exec" "${playerctl} play-pause")
          (key "Right" "Super" "exec" "${playerctl} next")
          (key "Down" "Super" "exec" "${swayosd-client} --brightness lower")
          (key "Up" "Super" "exec" "${swayosd-client} --brightness raise")
        ];

        # Release binds
        bindr = [
          (key "Alt_L" "Super+Alt" "togglespecialworkspace" "music")
          (key "Alt_L" "Super+Alt+Shift" "movetoworkspacesilent" "special:music")
          (key "Control_L" "Super+Ctrl" "togglespecialworkspace" "office")
          (key "Control_L" "Super+Ctrl+Shift" "movetoworkspacesilent" "special:office")
          (key "Shift_L" "Super+Shift" "workspace" "previous")
          (key "Super_L" "Super" "exec" menu)
          (key "Super_L" "Super+Ctrl+Shift" "exec" "${menu} network")
          (key "Super_L" "Super+Shift" "exec" "${menu} search")
        ];

        # Regular binds
        bind = [
          (key "mouse:274" "Super" "layoutmsg" "swapwithmaster auto")
          (key "mouse:274" "Super+Shift" "layoutmsg" "addmaster")
          (key "mouse:274" "Super+Ctrl+Shift" "layoutmsg" "removemaster")

          (key "Backslash" "Super" "splitratio" "exact 0.5") # Reset layout ratio
          (key "Backslash" "Super+Shift" "layoutmsg" "orientationcycle center left")
          (key "Backspace" "Super" "changegroupactive" "f")
          (key "Backspace" "Super+Ctrl" "togglegroup" null)
          (key "Backspace" "Super+Ctrl+Shift" "lockactivegroup" "toggle")
          (key "Backspace" "Super+Shift" "movegroupwindow" null)
          (key "Bracketleft" "Super" "splitratio" "-0.1")
          (key "Bracketleft" "Super+Shift" "layoutmsg" "rollnext")
          (key "Bracketright" "Super" "splitratio" "+0.1")
          (key "Bracketright" "Super+Shift" "layoutmsg" "rollprev")
          (key "Comma" "Super" "layoutmsg" "swapprev")
          (key "Delete" "Super+Shift" "exec" power)
          (key "Down" "Super+Shift" "movewindoworgroup" "d")
          (key "Equal" "Super+Shift" "exec" "${zoom} +0.1")
          (key "Escape" "Super" "togglefloating" null)
          (key "Escape" "Super+Alt" "exec" "lifx state --color red")
          (key "Escape" "Super+Shift" "centerwindow" null)
          (key "Grave" "Super" "togglespecialworkspace" "scratchpad")
          (key "Grave" "Super+Shift" "movetoworkspacesilent" "special:scratchpad")
          (key "Left" "Super+Alt" "exec" "${left} --scroll kensington-orbit-wireless-tb-mouse")
          (key "Left" "Super+Shift" "movewindoworgroup" "l")
          (key "Minus" "Super+Shift" "exec" "${zoom} -0.1")
          (key "Period" "Super" "layoutmsg" "swapnext")
          (key "Apostrophe" "Super" "exec" "${screenshot} selection")
          (key "Apostrophe" "Super+Shift" "exec" "${screenshot} display")
          (key "Apostrophe" "Super+Alt" "exec" "${screenshot} selection --edit")
          (key "Apostrophe" "Super+Alt+Shift" "exec" "${screenshot} display --edit")
          (key "Return" "Super" "fullscreen" "1") # Maximize
          (key "Return" "Super+Shift" "fullscreen" "0") # Fullscreen
          (key "Right" "Super+Shift" "movewindoworgroup" "r")
          (key "Semicolon" "Super" "exec" "${hyprpicker} --autocopy")
          (key "Semicolon" "Super+Shift" "exec" "${hyprpicker} --autocopy --format rgb")
          (key "Slash" "Super" "exec" vrr)
          (key "Space" "Ctrl" "exec" (concatStringsSep " " [
            "${toggle}"
            "--focus"
            "--type class"
            "--expression '^dropdown$'"
            "--workspace special:dropdown"
            "--"
            "${kitty} --app-id dropdown --override font_size=12"
          ]))
          (key "Space" "Ctrl+Alt" "exec" "lifx toggle")
          (key "Space" "Ctrl+Shift" "exec" (concatStringsSep " " [
            "${toggle}"
            "--type title"
            "--expression '^Picture.in.[Pp]icture$'"
            "--workspace special:pip"
          ]))
          (key "Space" "Super+Ctrl+Shift" "exec" (with config.custom;
            concatStringsSep " " [
              "${window} move"
              "--current"
              "--property title"
              "'^Picture.in.[Pp]icture$'"
              "${toString (gap + border)},${toString (gap + border)}"
            ]))
          (key "Tab" "Super" "layoutmsg" "cyclenext")
          (key "Tab" "Super+Shift" "alterzorder" "top")
          (key "Tab" "Super+Shift" "cyclenext" "floating")
          (key "Up" "Super+Shift" "movewindoworgroup" "u")

          (key "0" "Super+Shift" "exec" zoom)
          (key "1" "Ctrl+Alt" "exec" "lifx state --brightness 0.01")
          (key "1" "Super" "workspace" "1")
          (key "1" "Super+Alt" "exec" "lifx state --kelvin 1500")
          (key "1" "Super+Shift" "movetoworkspacesilent" "1")
          (key "2" "Ctrl+Alt" "exec" "lifx state --brightness 0.25")
          (key "2" "Super" "workspace" "2")
          (key "2" "Super+Alt" "exec" "lifx state --kelvin 2500")
          (key "2" "Super+Shift" "movetoworkspacesilent" "2")
          (key "3" "Ctrl+Alt" "exec" "lifx state --brightness 0.50")
          (key "3" "Super" "workspace" "3")
          (key "3" "Super+Alt" "exec" "lifx state --kelvin 3000")
          (key "3" "Super+Shift" "movetoworkspacesilent" "3")
          (key "4" "Ctrl+Alt" "exec" "lifx state --brightness 0.75")
          (key "4" "Super" "workspace" "4")
          (key "4" "Super+Alt" "exec" "lifx state --kelvin 4000")
          (key "4" "Super+Shift" "movetoworkspacesilent" "4")
          (key "5" "Ctrl+Alt" "exec" "lifx state --brightness 1.00")
          (key "5" "Super" "workspace" "5")
          (key "5" "Super+Alt" "exec" "lifx state --kelvin 5000")
          (key "5" "Super+Shift" "movetoworkspacesilent" "5")
          (key "6" "Super" "workspace" "6")
          (key "6" "Super+Shift" "movetoworkspacesilent" "6")
          (key "7" "Super" "workspace" "7")
          (key "7" "Super+Shift" "movetoworkspacesilent" "7")
          (key "8" "Super" "workspace" "8")
          (key "8" "Super+Shift" "movetoworkspacesilent" "8")
          (key "9" "Super" "exec" audio)
          (key "A" "Ctrl+Alt" "exec" "${waydroid} session stop")
          (key "A" "Super" "togglespecialworkspace" "android")
          (key "A" "Super+Shift" "movetoworkspacesilent" "special:android")
          (key "B" "Super" "exec" config.custom.browser.command)
          (key "C" "Super" "exec" codium)
          (key "E" "Super" "exec" gnome-text-editor)
          (key "F" "Super" "exec" "${nautilus} --new-window")
          (key "G" "Super" "workspace" "name:game")
          (key "G" "Super+Alt" "togglespecialworkspace" "gamescope")
          (key "G" "Super+Ctrl+Alt" "exec" "${pkill} gamescope")
          (key "G" "Super+Shift" "movetoworkspacesilent" "name:game")
          (key "K" "Super" "exec" obsidian)
          (key "O" "Super" "togglespecialworkspace" "wallpaper")
          (key "O" "Super+Shift" "movetoworkspacesilent" "special:wallpaper")
          (key "P" "Ctrl+Alt" "exec" "${pkill} 1password")
          (key "P" "Super" "togglespecialworkspace" "password")
          (key "P" "Super+Shift" "movetoworkspacesilent" "special:password")
          (key "Q" "Ctrl+Alt" "exec" "${kill} -9 $(${hyprctl} -j activewindow | ${jq} .pid)")
          #// (key "Q" "Ctrl+Alt+Shift" "exec" "close") # Quit all windows
          (key "Q" "Super" "killactive" null)
          (key "S" "Ctrl+Alt" "exec" "${pkill} steam")
          (key "S" "Super" "togglespecialworkspace" "steam")
          (key "S" "Super+Shift" "movetoworkspacesilent" "special:steam")
          (key "S" "Super+Ctrl" "exec" steam)
          (key "T" "Ctrl+Alt" "exec" "${pkill} kitty")
          (key "T" "Super" "togglespecialworkspace" "terminal")
          (key "T" "Super+Ctrl" "exec" kitty)
          (key "T" "Super+Shift" "movetoworkspacesilent" "special:terminal")
          (key "V" "Super" "exec" "${menu} clipboard")
          (key "V" "Super+Shift" "exec" "${rm} ~/.cache/walker/clipboard.gob && ${notify-send} menu 'Clipboard cleared' --urgency low")
          (key "W" "Super" "togglespecialworkspace" "vm")
          (key "W" "Super+Ctrl" "exec" ''${remote} --vm --client xfreerdp --username Myned --password "$(${cat} ${config.age.secrets."desktop/vm/myndows.pass".path})" ${
              if config.custom.hidpi
              then "--scale 140"
              else ""
            } myndows'')
          (key "W" "Super+Ctrl+Shift" "exec" virt-manager)
          (key "W" "Super+Shift" "movetoworkspacesilent" "special:vm")
          (key "X" "Super" "workspace" "+1")
          (key "X" "Super+Shift" "movetoworkspacesilent" "+1")
          (key "Z" "Super" "workspace" "-1")
          (key "Z" "Super+Shift" "movetoworkspacesilent" "-1")
        ];
      };
    };
  };
}
