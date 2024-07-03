{
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;

  spicePkgs = inputs.spicetify.packages.${pkgs.stdenv.system}.default;
in {
  imports = [inputs.spicetify.homeManagerModule];
  config = mkIf prg.spotify.enable {
    programs.spicetify = {
      enable = true;

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      spotifyPackage = pkgs.spotify;
      injectCss = true;
      replaceColors = true;

      overwriteAssets = true;
      sidebarConfig = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyrics-plus
        new-releases
      ];

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        playlistIcons
        lastfm
        genre
        historyShortcut
        bookmark
        fullAlbumDate
        groupSession
        popupLyrics
      ];
    };
  };
}
