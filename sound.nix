{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.alsa-utils ];
  users.users.akegalj.packages = [ pkgs.pavucontrol ];
  # Bellow is pulseaudio/alsa config from 24.05
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/audio/alsa.nix#L89
  # Pipewire also works fine but I have managed to have better sound quality with less config
  # using pulseaudio

  hardware.pulseaudio.enable = true;
  # ALSA provides a udev rule for restoring volume settings.
  services.udev.packages = [ pkgs.alsa-utils ];

  systemd.services.alsa-store =
    { description = "Store Sound Card State";
      wantedBy = [ "multi-user.target" ];
      unitConfig.RequiresMountsFor = "/var/lib/alsa";
      unitConfig.ConditionVirtualization = "!systemd-nspawn";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
        ExecStop = "${pkgs.alsa-utils}/sbin/alsactl store --ignore";
      };
    };
  # We need bluetooth headset only on system76 meerkat
  # TODO: conditionally enable there only?
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  # Pair with https://nixos.wiki/wiki/Bluetooth
  # Use `bluetoothctl power on` to connect
  # Use `bluetoothctl power off` to disconnect` to connect
  hardware.bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.pipewire.enable = false;

  # If you want to switch to pupewire instead of pulseaudio uncumment bellow
#   services.pipewire.wireplumber.extraConfig."10-bluez" = {
#     "monitor.bluez.properties" = {
#       "bluez5.enable-sbc-xq" = true;
#       "bluez5.enable-msbc" = true;
#       "bluez5.enable-hw-volume" = true;
#       "bluez5.roles" = [
#         "hsp_hs"
#         "hsp_ag"
#         "hfp_hf"
#         "hfp_ag"
#       ];
#     };
#   };
}
