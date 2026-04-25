{ config, lib, pkgs, ... }:

# Laptop-profil for Dell XPS 13 9350 (Skylake, 15W TDP).
# - TLP for batteri (erstatter power-profiles-daemon)
# - thermald (allerede aktivert via cpu/intel.nix)

{
  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
  ];

  # ── TLP: bedre batteritid enn power-profiles-daemon ──
  # Plasma 6 aktiverer ppd som default — overstyr.
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Plattform-profil (PCI/ASPM/SATA m.m.)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Skjerm-backlight via intel_backlight
      DISK_DEVICES = "nvme0n1";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";

      # WiFi powersave på batteri
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # USB autosuspend, men ikke for input-enheter
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;

      # Battery charge thresholds (Dell støtter dette via dell-laptop-modulen)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

}
