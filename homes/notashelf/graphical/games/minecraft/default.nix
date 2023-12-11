{
  lib,
  pkgs,
  osConfig,
  inputs',
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.programs;
  dev = osConfig.modules.device;
  env = osConfig.modules.usrEnv;

  acceptedTypes = ["laptop" "desktop" "lite"];

  catppuccin-mocha = pkgs.fetchzip {
    url = "https://raw.githubusercontent.com/catppuccin/prismlauncher/main/themes/Mocha/Catppuccin-Mocha.zip";
    sha256 = "8uRqCoe9iSIwNnK13d6S4XSX945g88mVyoY+LZSPBtQ=";
  };

  # java packages that are needed by various versions or modpacks
  # different distributions of java may yield different results in performance
  # and thus I recommend testing them one by one to remove those that you do not
  # need in your configuration
  javaPackages = with pkgs; [
    # Java 8
    temurin-jre-bin-8
    zulu8
    # Java 11
    temurin-jre-bin-11
    # Java 17
    temurin-jre-bin-17
    # Latest
    temurin-jre-bin
    zulu
    graalvm-ce
  ];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.gaming.enable) {
    home = {
      # copy the catppuccin theme to the themes directory of PrismLauncher
      file.".local/share/PrismLauncher/themes/mocha" = {
        source = catppuccin-mocha;
        recursive = true;
      };

      packages = let
        glfw =
          if env.isWayland
          then pkgs.glfw-wayland-minecraft
          else pkgs.glfw;
      in [
        # the successor to polyMC, which is now mostly abandoned
        (inputs'.prism-launcher.packages.prismlauncher.override {
          # get java versions required by various minecraft versions
          # "write once run everywhere" my ass
          jdks = javaPackages;
          # wrap prismlauncher with programs in may need for workarounds
          # or client features
          additionalPrograms = with pkgs; [
            gamemode
            mangohud
            jprofiler
          ];

          # prismlauncher's glfw version to properly support wayland
          inherit glfw;
        })
      ];
    };
  };
}
