{ pkgs, lib, config, ... }:

{
  programs.mpv = {
    enable = true;

    # Default-profil tunet for Intel HD 520 / Iris 540 (Skylake) på Dell XPS
    # 13 9350. 1080p laptop-panel + valgfri 4K TV via USB-C/DP. Ingen dGPU.
    config = {
      # ── Output ──
      vo = "gpu";
      gpu-api = "opengl";
      gpu-context = "auto";

      # ── HW decode: VAAPI på Intel iGPU (iHD-driver) ──
      # Skylake HD 520/Iris 540: H.264 8-bit + HEVC 8-bit hwdec full speed.
      # HEVC 10-bit: hybrid (delvis sw), kan stamme på høy bitrate.
      hwdec = "vaapi";
      hwdec-codecs = "all";

      # ── Frame timing ──
      # display-resample retimer audio til skjerm-refresh.
      # interpolation=no: Skylake iGPU har ikke headroom til ekstra
      # shader-pass. Gir 24->60 judder, men ingen frame-drop.
      video-sync = "display-resample";
      interpolation = "no";

      # ── Scaling: spline36 = skarp + billig på 1080p ──
      scale = "spline36";
      cscale = "spline36";
      dscale = "mitchell";
      sigmoid-upscaling = "yes";
      dither-depth = "auto";

      # ── Audio: PCM via PipeWire ──
      ao = "pipewire";
      audio-channels = "auto-safe";
      audio-exclusive = "no";
      volume = "100";
      volume-max = "150";

      # ── Cache: absorber jitter på lokal-disk og nett-stream ──
      cache = "yes";
      cache-secs = 60;
      demuxer-max-bytes = "256MiB";
      demuxer-max-back-bytes = "64MiB";
      demuxer-readahead-secs = 30;
      demuxer-seekable-cache = "yes";
      stream-buffer-size = "8MiB";
      network-timeout = 30;

      # ── UI ──
      keep-open = "yes";
      cursor-autohide = 1000;
      osc = "yes";
      hr-seek = "yes";
      save-position-on-quit = "yes";

      # ── Subs / språk ──
      sub-auto = "fuzzy";
      slang = "no,nob,en,eng";
      alang = "no,nob,en,eng";
      sub-font-size = 36;
      sub-border-size = 2;
      sub-shadow-offset = 0;

      # ── Screenshots ──
      screenshot-format = "png";
      screenshot-directory = "~/Pictures/mpv";

      # ── Shader-cache ──
      gpu-shader-cache-dir = "~/.cache/mpv/shaders";
    };

    profiles = {
      # 4K TV-output: la TVen skalere, bruk billig scaler så Skylake iGPU
      # slipper å skalere 1080p->4K i shader. Aktiveres når vinduet ligger
      # på >=3000px bred skjerm.
      "tv-4k" = {
        profile-cond = ''(get("display-width") or 0) >= 3000'';
        profile-restore = "copy-equal";
        scale = "bilinear";
        cscale = "bilinear";
        dscale = "bilinear";
        interpolation = "no";
        sigmoid-upscaling = "no";
      };

      # 4K-kilde: tung på Skylake. Tving billig scaler.
      "src-4k" = {
        profile-cond = "width >= 3000";
        profile-restore = "copy-equal";
        scale = "bilinear";
        cscale = "bilinear";
        deband = "no";
      };

      # HEVC 10-bit-hybrid stammer på Skylake iGPU. Slå av deband og
      # bruk billigste scaler — hindrer frame-drop på tunge encodes.
      "hevc-10bit" = {
        profile-cond = ''get("video-params/pixelformat") == "yuv420p10"'';
        profile-restore = "copy-equal";
        scale = "bilinear";
        cscale = "bilinear";
        deband = "no";
        sigmoid-upscaling = "no";
      };
    };

    bindings = {
      "MBTN_LEFT_DBL" = "cycle fullscreen";
      "F" = "cycle fullscreen";
      "I" = "cycle interpolation";
    };
  };
}
