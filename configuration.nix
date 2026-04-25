
{ inputs, config, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./modules/core/default.nix
      ];

    networking.hostName = "laptop-sno";
    system.stateVersion = "25.11"; 
}
