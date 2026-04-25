{ config, pkgs, lib, ... }:

{
  users.mutableUsers = true;

  users.users.synnove = {
    isNormalUser = true;
    description = "Synnøve";
    home = "/home/synnove";
    shell = pkgs.bashInteractive;
    initialPassword = "nixly";
    extraGroups = [
      "wheel"
      "networkmanager"
      "bluetooth"
      "disk"
      "power"
      "video"
      "audio"
      "render"
      "systemd-journal"
      "dialout"
      "input"
      "uinput"
    ];
    openssh.authorizedKeys.keys = [];
  };

  users.groups.uinput = {};
}
