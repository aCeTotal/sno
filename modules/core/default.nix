{ ... }:

{
  imports = [
    ./boot.nix
    ./kde.nix
    ./networking.nix
    ./nix.nix
    ./nfs.nix
    ./ssh.nix
    ./packages.nix
    ./users.nix
    ./timezone_locale.nix
    ./system_services.nix
    ./wayland.nix
    ./sound.nix
    ./zram.nix
    ./security.nix
    ./gpu/intel_skylake.nix
    ./cpu/intel.nix
    ./newsboat.nix
    ./laptop.nix
  ];
}
