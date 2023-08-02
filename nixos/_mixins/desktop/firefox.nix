{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.unstable.firefox;
    extensions = (with pkgs.nur.repos.rycee.firefox-addons; [
    darkreader
    privacy-badger
    ublock-origin
    bitwarden
    vimium
    ]);
  };
}