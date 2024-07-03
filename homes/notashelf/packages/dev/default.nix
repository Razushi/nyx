{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.dev.enable {
    home.packages = [
      # LaTeX
      pkgs.texlive.combined.scheme-full
      (pkgs.writeShellApplication {
        name = "pdflatexmk";
        runtimeInputs = [pkgs.texlivePackages.latexmk];
        text = ''
          latexmk -pdf "$@" && latexmk -c "$@"
        '';
      })
    ];
  };
}
