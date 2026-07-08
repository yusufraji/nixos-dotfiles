{ pkgs }:
{
  enable = true;
  package = pkgs.firefox;

  languagePacks = [
    "en-US"
    "de"
  ];

  profiles.default = {
    search.default = "ddg";
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.startup.homepage" = "https://nixos.org";
      "privacy.donottrackheader.enabled" = true;
      "privacy.resistFingerprinting" = true;
      "browser.newtabpage.pinned" = [
        {
          title = "youtube";
          url = "https://www.youtube.com/";
        }
      ];
    };
    userChrome = builtins.readFile ../firefox/chrome/userChrome.css;

  };

}
