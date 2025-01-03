{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.custom.desktops.niri.binds;
  hm = config.home-manager.users.${config.custom.username};

  audio = config.home-manager.users.${config.custom.username}.home.file.".local/bin/audio".source;
  bash = "${pkgs.bash}/bin/bash";
  cat = "${pkgs.coreutils}/bin/cat";
  codium = "${config.home-manager.users.${config.custom.username}.programs.vscode.package}/bin/codium";
  hyprlock = "${config.home-manager.users.${config.custom.username}.programs.hyprlock.package}/bin/hyprlock";
  hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
  inhibit = config.home-manager.users.${config.custom.username}.home.file.".local/bin/inhibit".source;
  kitty = "${config.home-manager.users.${config.custom.username}.programs.kitty.package}/bin/kitty";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  loupe = "${pkgs.loupe}/bin/loupe";
  nautilus = "${pkgs.nautilus}/bin/nautilus";
  networkmanager_dmenu = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  niri = "${config.programs.niri.package}/bin/niri";
  obsidian = "${pkgs.obsidian}/bin/obsidian";
  pkill = "${pkgs.procps}/bin/pkill";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  power = config.home-manager.users.${config.custom.username}.home.file.".local/bin/power".source;
  remote = config.home-manager.users.${config.custom.username}.home.file.".local/bin/remote".source;
  rm = "${pkgs.coreutils}/bin/rm";
  steam = "${config.programs.steam.package}/bin/steam";
  swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
  virt-manager = "${config.programs.virt-manager.package}/bin/virt-manager";
  walker = "${config.home-manager.users.${config.custom.username}.programs.walker.package}/bin/walker";
  waydroid = "${pkgs.waydroid}/bin/waydroid";
  _1password = "${config.programs._1password-gui.package}/bin/1password";
  youtube-music = "${pkgs.youtube-music}/bin/youtube-music";
in {
  options.custom.desktops.niri.binds = {
    enable = mkOption {default = false;};
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        # https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings
        # https://github.com/sodiboo/niri-flake/blob/main/docs.md#programsnirisettingsbinds
        #?? Mod = Super/Win, Alt when nested; Mod5 = AltGr
        #?? wev
        programs.niri.settings.binds = let
          # Swap modifiers and key for alphabetical sorting
          #?? (key "KEY" "MODIFIERS" (ACTION "ARGUMENT"))
          key = key: modifiers: action: {
            name = "${
              if (isString modifiers)
              then "${modifiers}+"
              else ""
            }${key}";
            value = {inherit action;};
          };

          # Launch VM
          vm = ''${remote} --vm --client xfreerdp --username Myned --password "$(${cat} ${config.age.secrets."desktop/vm/myndows.pass".path})" ${
              if config.custom.hidpi
              then "--scale 140"
              else ""
            } myndows'';
        in
          listToAttrs (with hm.lib.niri.actions; [
            (key "0" "Mod" (spawn [swayosd-client "--output-volume" "mute-toggle"]))
            (key "1" "Ctrl+Alt" (spawn ["lifx" "state" "--brightness" "0.01"]))
            (key "1" "Mod" (focus-workspace "1"))
            (key "1" "Mod+Alt" (spawn ["lifx" "state" "--kelvin" "1500"]))
            (key "1" "Mod+Shift" (move-column-to-workspace "1"))
            (key "2" "Ctrl+Alt" (spawn ["lifx" "state" "--brightness" "0.25"]))
            (key "2" "Mod" (focus-workspace "2"))
            (key "2" "Mod+Alt" (spawn ["lifx" "state" "--kelvin" "2500"]))
            (key "2" "Mod+Shift" (move-column-to-workspace "2"))
            (key "3" "Ctrl+Alt" (spawn ["lifx" "state" "--brightness" "0.50"]))
            (key "3" "Mod" (focus-workspace "3"))
            (key "3" "Mod+Alt" (spawn ["lifx" "state" "--kelvin" "3000"]))
            (key "3" "Mod+Shift" (move-column-to-workspace "3"))
            (key "4" "Ctrl+Alt" (spawn ["lifx" "state" "--brightness" "0.75"]))
            (key "4" "Mod" (focus-workspace "4"))
            (key "4" "Mod+Alt" (spawn ["lifx" "state" "--kelvin" "4000"]))
            (key "4" "Mod+Shift" (move-column-to-workspace "4"))
            (key "5" "Ctrl+Alt" (spawn ["lifx" "state" "--brightness" "1.00"]))
            (key "5" "Mod" (focus-workspace "5"))
            (key "5" "Mod+Alt" (spawn ["lifx" "state" "--kelvin" "5000"]))
            (key "5" "Mod+Shift" (move-column-to-workspace "5"))
            (key "6" "Mod" (focus-workspace "6"))
            (key "6" "Mod+Shift" (move-column-to-workspace "6"))
            (key "7" "Mod" (focus-workspace "7"))
            (key "7" "Mod+Shift" (move-column-to-workspace "7"))
            (key "8" "Mod" (focus-workspace "8"))
            (key "8" "Mod+Shift" (move-column-to-workspace "8"))
            (key "9" "Mod" (spawn audio))
            (key "A" "Ctrl+Alt" (spawn [waydroid "session" "stop"]))
            (key "A" "Mod" focus-column-or-monitor-left)
            (key "A" "Mod+Ctrl" consume-or-expel-window-left)
            (key "A" "Mod+Shift" move-column-left-or-to-monitor-left)
            (key "Apostrophe" "Mod" screenshot)
            (key "Apostrophe" "Mod+Ctrl+Shift" screenshot-screen)
            (key "Apostrophe" "Mod+Shift" screenshot-window)
            (key "B" "Ctrl+Alt" (spawn [pkill config.custom.browser.command]))
            (key "B" "Mod" (spawn config.custom.browser.command))
            (key "Backslash" "Mod" (spawn inhibit))
            (key "Backslash" "Mod+Shift" (spawn power))
            (key "Bracketleft" "Mod" (switch-layout "prev"))
            (key "Bracketright" "Mod" (switch-layout "next"))
            (key "C" "Mod" (spawn [walker "--modules" "clipboard"]))
            (key "C" "Mod+Ctrl" (spawn [bash "-c" "${rm} ~/.cache/walker/clipboard.gob && ${notify-send} menu 'Clipboard cleared' --urgency low"]))
            (key "Delete" "Ctrl+Alt" (spawn [loginctl "terminate-user" config.custom.username]))
            (key "Delete" "Mod" (spawn [playerctl] "play-pause"))
            (key "Down" "Mod" (spawn [swayosd-client "--brightness" "lower"]))
            (key "E" "Ctrl+Alt" (spawn [pkill "codium"]))
            (key "E" "Mod" (spawn codium))
            (key "Equal" "Mod" (spawn [swayosd-client "--output-volume" "raise"]))
            (key "Escape" "Mod" toggle-window-floating)
            (key "Escape" "Mod+Alt" (spawn ["lifx" "state" "--color" "red"]))
            (key "F" "Mod" (spawn [nautilus "--new-window"]))
            (key "G" "Ctrl+Alt" (spawn [pkill "steam"]))
            (key "G" "Mod" (spawn steam))
            (key "K" "Ctrl+Alt" (spawn [pkill "obsidian"]))
            (key "K" "Mod" (spawn obsidian))
            (key "L" "Mod" (spawn [bash "-c" "${hyprlock} --immediate & ${niri} msg action power-off-monitors"]))
            (key "L" "Mod+Shift" suspend)
            (key "Left" "Mod" (spawn [playerctl "previous"]))
            (key "M" "Ctrl+Alt" (spawn [pkill "youtube-music"]))
            (key "M" "Mod" (spawn youtube-music))
            (key "Minus" "Mod" (spawn [swayosd-client "--output-volume" "lower"]))
            (key "O" "Mod" (spawn [loupe "/tmp/wallpaper.png"]))
            (key "P" "Ctrl+Alt" (spawn [pkill "1password"]))
            (key "P" "Mod" (spawn _1password))
            (key "Q" "Mod" close-window)
            (key "R" "Mod" focus-window-or-workspace-down)
            (key "R" "Mod+Shift" move-window-down-or-to-workspace-down)
            (key "Return" "Mod" maximize-column)
            (key "Return" "Mod+Ctrl" center-column)
            (key "Return" "Mod+Shift" fullscreen-window)
            (key "Right" "Mod" (spawn [playerctl "next"]))
            (key "S" "Mod" focus-column-or-monitor-right)
            (key "S" "Mod+Ctrl" consume-or-expel-window-right)
            (key "S" "Mod+Shift" move-column-right-or-to-monitor-right)
            (key "Semicolon" "Mod" (spawn [hyprpicker "--autocopy"]))
            (key "Semicolon" "Mod+Shift" (spawn [hyprpicker "--autocopy --format rgb"]))
            (key "Slash" "Mod+Shift" show-hotkey-overlay)
            (key "Space" "Ctrl+Alt" (spawn ["lifx" "toggle"]))
            (key "Space" "Ctrl+Alt" (spawn ["lifx" "toggle"]))
            (key "T" "Ctrl+Alt" (spawn [pkill "kitty"]))
            (key "T" "Mod" (spawn kitty))
            (key "Tab" "Mod" switch-focus-between-floating-and-tiling)
            (key "Up" "Mod" (spawn [swayosd-client "--brightness" "raise"]))
            (key "V" "Mod" (spawn virt-manager))
            (key "V" "Mod+Ctrl" (spawn vm))
            (key "W" "Mod" focus-window-or-workspace-up)
            (key "W" "Mod+Shift" move-window-up-or-to-workspace-up)
            (key "WheelScrollDown" "Mod" focus-window-or-workspace-down)
            (key "WheelScrollDown" "Mod+Shift" move-window-down-or-to-workspace-down)
            (key "WheelScrollLeft" "Mod" focus-column-or-monitor-left)
            (key "WheelScrollLeft" "Mod+Shift" move-column-left-or-to-monitor-left)
            (key "WheelScrollRight" "Mod" focus-column-or-monitor-right)
            (key "WheelScrollRight" "Mod+Shift" move-column-right-or-to-monitor-right)
            (key "WheelScrollUp" "Mod" focus-window-or-workspace-up)
            (key "WheelScrollUp" "Mod+Shift" move-window-up-or-to-workspace-up)
            #// (key "X" "Mod" switch-preset-column-width)
            (key "X" "Mod" (set-column-width "+10%"))
            (key "X" "Mod+Shift" (set-window-height "+10%"))
            #// (key "Z" "Mod" switch-preset-window-height)
            (key "Z" "Mod" (set-column-width "-10%"))
            (key "Z" "Mod+Shift" (set-window-height "-10%"))

            # BUG: Release binds execute with all binds involving that modifier
            # https://github.com/YaLTeR/niri/issues/605
            # TODO: Uncomment when fixed
            #// (key "Shift_L" "Mod" focus-workspace-previous)
            # TODO: Use "Super_L" when fixed
            (key "Space" "Mod" (spawn walker))
            (key "Space" "Mod+Ctrl+Shift" (spawn networkmanager_dmenu))
            (key "Space" "Mod+Shift" (spawn [walker "--modules" "search"]))

            # Media keys
            # https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
            (key "XF86AudioMute" null (spawn [swayosd-client "--output-volume" "mute-toggle"])) # F1
            (key "XF86AudioLowerVolume" null (spawn [swayosd-client "--output-volume" "lower"])) # F2
            (key "XF86AudioRaiseVolume" null (spawn [swayosd-client "--output-volume" "raise"])) # F3
            (key "XF86AudioPrev" null (spawn [playerctl "previous"])) # F4
            (key "XF86AudioPlay" null (spawn [playerctl "play-pause"])) # F5
            (key "XF86AudioNext" null (spawn [playerctl "next"])) # F6
            (key "XF86MonBrightnessDown" null (spawn [swayosd-client "--brightness" "lower"])) # F7
            (key "XF86MonBrightnessUp" null (spawn [swayosd-client "--brightness" "raise"])) # F8
            (key "XF86AudioMedia" null (spawn [notify-send "test"])) # F12
          ]);
      }
    ];
  };
}
