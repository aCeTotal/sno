{ config, lib, pkgs, ... }:

# Intel Skylake iGPU-profil — HD Graphics 520 / Iris 540.
# Brukt på Dell XPS 13 9350 (P54G). Ingen dGPU.
#
# - Kernel-modul: i915 (Skylake; xe-driveren er for Arc/Lunar Lake+)
# - VA-API: iHD (intel-media-driver) som primær, i965 som fallback
# - Vulkan: ANV via mesa
# - PSR=0: Panel Self-Refresh gir flicker på XPS-paneler
# - GuC+HuC: kreves for full HEVC hwdec og bedre GPU-scheduling
# - Wayland-default for Chrome/Electron/Qt/SDL/Firefox

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      intel-media-driver       # iHD: HEVC/H.264/VP9 dekode på Skylake+
      intel-vaapi-driver       # i965: legacy fallback
      libvdpau-va-gl
      vpl-gpu-rt               # OneVPL runtime
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      # Panel Self-Refresh av: kjent flicker-bug på XPS 13-paneler.
      "i915.enable_psr=0"
      # Framebuffer compression: kutter strøm på idle/lite oppdatering.
      "i915.enable_fbc=1"
      # GuC + HuC firmware (verdi 2): kreves for full HEVC hwdec.
      "i915.enable_guc=2"
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
    intel-gpu-tools
    mesa-demos
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
