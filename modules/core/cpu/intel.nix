{ config, lib, pkgs, ... }:

{
  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelParams = lib.mkBefore [ "intel_pstate=active" ];

  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    cpufrequtils
  ];
}
