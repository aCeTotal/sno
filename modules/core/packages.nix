{ lib, pkgs-stable, system, inputs, ... }:

let
  stablePackages = with pkgs-stable; [
    discord
    google-chrome
    gimp
    celluloid
    grim
    slurp
    wl-clipboard
    spotify
    vlc
    onlyoffice-desktopeditors
    pavucontrol
  ];
in
{
  config.home-manager.sharedModules = [
    {
      home.packages = stablePackages;
    }
  ];
}
