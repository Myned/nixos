let
  # https://wiki.nixos.org/wiki/Agenix
  # https://github.com/ryantm/agenix
  #?? cd secrets/
  #?? agenix --edit file.age
  #?? agenix --rekey
  # Users that imperatively encrypt age files
  #!! Imperative client key generation
  #?? ssh-keygen -f ~/.ssh/id_ed25519 -N ''
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcKnHQnd75sTQa8EchKbanEb8w26g53TY9QAp5NZxUa myned@mynix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9ekzJc0RvrxIVAanfqkns7DpRdG2+UGPE5prx4h11a myned@myork"
  ];

  # Profiles that decrypt age files during activation
  #!! Imperative host key generation without sshd service
  #?? sudo ssh-keygen -f /etc/ssh/id_ed25519 -N ''
  consoles = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh8nTTOUsmKQa7zIftN2k8BgbQbXENc98KSJIyorMON root@myeck"
  ];

  desktops = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKKqfRtKZ+8Qm9DjurAJ8Ob4IZjAWZQjNGQXgQVRr8M root@mynix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGoIYRj59beHz2S1NNQaC34SteLHbhG7BZAeQ8bmUp0g root@myork"
  ];

  sbcs = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUu7C0uj4Ia5Xzttbeq3em1DbhEdMDrm9MOoFcw+BLU root@mypi3"
  ];

  servers = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPlG7FWZ5Us4Ix5fGMHn2DJU1/ma/7kQu39cPKKQMXJ root@myarm"
  ];

  common = users ++ consoles ++ desktops ++ sbcs ++ servers;
  console = users ++ consoles;
  desktop = users ++ desktops;
  sbc = users ++ sbcs;
  server = users ++ servers;
in {
  # TODO: Move secrets into each profile
  #?? config.age.secrets."PROFILE/SECRET".path

  ### Common
  "common/nix/access-tokens.conf".publicKeys = common;
  "common/tailscale/tailnet".publicKeys = common;

  ### Console
  "console/users/myned.pass".publicKeys = console;
  "console/users/root.pass".publicKeys = console;

  ### Desktop
  "desktop/bitwarden/client_id".publicKeys = desktop;
  "desktop/bitwarden/client_secret".publicKeys = desktop;
  "desktop/geoclue2/geolocation".publicKeys = desktop;
  "desktop/users/myned.pass".publicKeys = desktop;
  "desktop/users/root.pass".publicKeys = desktop;

  ### SBC
  "sbc/borgmatic/borgbase.mypi3".publicKeys = sbc;
  "sbc/create_ap/passphrase".publicKeys = sbc;
  "sbc/create_ap/ssid".publicKeys = sbc;
  "sbc/netdata/child.conf".publicKeys = sbc;
  "sbc/users/myned.pass".publicKeys = sbc;
  "sbc/users/root.pass".publicKeys = sbc;

  ### Server
  "server/borgmatic/borgbase.myarm".publicKeys = server;
  "server/caddy/Caddyfile".publicKeys = server;
  "server/coturn/coturn.conf".publicKeys = server;
  "server/forgejo/.env".publicKeys = server;
  "server/forgejo/db.env".publicKeys = server;
  "server/foundryvtt/.env".publicKeys = server;
  "server/headscale/.env".publicKeys = server;
  "server/mastodon/.env".publicKeys = server;
  "server/mastodon/db.env".publicKeys = server;
  "server/matrix-conduit/conduwuit.toml".publicKeys = server;
  "server/netdata/parent.conf".publicKeys = server;
  "server/nextcloud/.env".publicKeys = server;
  "server/nextcloud/db.env".publicKeys = server;
  "server/searxng/.env".publicKeys = server;
  "server/users/myned.pass".publicKeys = server;
  "server/users/root.pass".publicKeys = server;
}
