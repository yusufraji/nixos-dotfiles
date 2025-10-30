# https://github.com/nix-community/home-manager/blob/master/modules/programs/bat.nix
{ pkgs }:
{
  enable = true;
  package = pkgs.bat;
  config = {
    theme = "ansi";
  };
  extraPackages = [ pkgs.bat-extras.batman ];
  themes = { };
  syntaxes = { };
}
