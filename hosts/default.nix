{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;

  # Bootloaders
  bl-common = ../modules/bootloaders/common.nix;
  bl-server = ../modules/bootloaders/server.nix;

  # shared modules
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  wayland = ../modules/wayland;
  server = ../modules/server;
  desktop = ../modules/desktop;

  # flake inputs
  hw = inputs.nixos-hardware.nixosModules;
  ragenix = inputs.ragenix.nixosModules.age;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  shared = [core ragenix];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.notashelf = ../modules/home;
  };
in {
  # desktop
  prometheus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "prometheus";}
        ./prometheus
        bl-common
        desktop
        #nvidia
        wayland
        hmModule
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  icarus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "icarus";}
        ./icarus
        bl-common
        server
        wayland
        hmModule
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # server
  atlas = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      [
        ./atlas
        bl-server
        hw.raspberry-pi-4
        server
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}
