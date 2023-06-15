{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.device;
in {
  config = {
    modules = {
      device = {
        type = "laptop";
        cpu = "intel";
        gpu = "intel";
        monitors = ["eDP-1"];
        hasBluetooth = false;
        hasSound = true;
        hasTPM = false;
      };
      system = {
        fs = ["btrfs" "vfat"];
        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;
        virtualization.enable = false;
        username = "notashelf";
      };
      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
      };
      programs = {
        git.signingKey = "0x84184B8533918D88";

        cli.enable = true;
        gui.enable = true;

        gaming = {
          enable = false;
          chess.enable = true;
        };

        default = {
          terminal = "foot";
        };

        override = {};
      };
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
    };

    boot = {
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
      kernelModules = [
        "iwlwifi"
      ];
    };
  };
}
