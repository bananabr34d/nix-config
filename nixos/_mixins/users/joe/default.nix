{ config, desktop, lib, pkgs, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # Only include desktop components if one is supplied.
  imports = [ ] ++ lib.optional (builtins.isString desktop) ./desktop.nix;

  environment.systemPackages = [
    pkgs.yadm # Terminal dot file manager
  ];

  users.users.joe = {
    description = "Joe Sullivan";
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "docker"
      "podman"
    ];
    # mkpasswd -m sha-512
    hashedPassword = "$6$JJeTkE.sH1vRSA5s$UK03NjikExwD93PEBEqHqC2D2gpLmrKzKUut7eiBQD0FQp51PWakALl3jIDUtNnQMe9BF5y9L/59vwfVxqxdY/";
    homeMode = "0755";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKm6tRLWHxEC0B2cMRvxBAInothWDPgH7CGUvuukdtu joe@carbon"
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };
}
