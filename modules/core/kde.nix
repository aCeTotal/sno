{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Default-sesjon: Wayland Plasma. "plasmax11" hvis X11.
  services.displayManager.defaultSession = "plasma";

  # Auto-unlock KWallet via PAM ved login (SDDM + TTY).
  # kwallet-pam fanger login-passord og låser opp default-wallet uten popup.
  # Krever at KWallet bruker samme passord som login. Ved fresh user lages
  # walleten automatisk med login-passord; eksisterende wallet med annet
  # passord -> slett ~/.local/share/kwalletd/kdewallet.kwl* så regenereres.
  security.pam.services.sddm.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
}
