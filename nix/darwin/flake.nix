{
  description = "Nix-Darwin systems and tools by yusuf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
    }:
    let
      locale = "de_DE.UTF-8";
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            vim
            nixd # nix lsp deamon
            nixfmt-rfc-style # nix language formatter
            nil

          ];
          environment.variables = {
            EDITOR = "hx";
            VISUAL = "hx";
            LANG = locale;
            LC_ALL = locale;
          };

          # Allows getting completion for system packages (e.g. systemd).
          environment.pathsToLink = [
            "/usr/share/zsh"
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.warn-dirty = false;

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };

          # Enable sudo authentication with Touch ID.
          security.pam.services.sudo_local.touchIdAuth = true;

          fonts.packages = with pkgs; [
            nerd-fonts.jetbrains-mono
            nerd-fonts.droid-sans-mono
            nerd-fonts.symbols-only
            nerd-fonts.iosevka
            noto-fonts-color-emoji
          ];

          time.timeZone = "Europe/Berlin";

          system.primaryUser = "yusufraji";

          system = {
            defaults = {
              controlcenter = {

                BatteryShowPercentage = true;
                Bluetooth = true;
                Display = true;
                FocusModes = true;
                NowPlaying = true;
                Sound = true;

              };
              trackpad = {
                Clicking = true;
                Dragging = true;
                TrackpadRightClick = true;
                TrackpadThreeFingerDrag = true;
                TrackpadThreeFingerTapGesture = 2;

              };
              dock.autohide = true;
              dock.autohide-delay = 0.24;
              dock.largesize = 17;
              dock.magnification = true;
              NSGlobalDomain = {
                AppleMeasurementUnits = "Centimeters";
                AppleMetricUnits = 1;
                AppleTemperatureUnit = "Celsius";
                AppleICUForce24HourTime = true;
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.sound.beep.feedback" = 1;
                "com.apple.springing.delay" = 0.5;
                "com.apple.springing.enabled" = true;
                "com.apple.swipescrolldirection" = true;
                "com.apple.trackpad.forceClick" = true;
                "com.apple.trackpad.enableSecondaryClick" = true;
                "com.apple.trackpad.scaling" = 3.0;
                # 120, 94, 68, 35, 25, 15
                InitialKeyRepeat = 15;
                # 120, 90, 60, 30, 12, 6, 2
                KeyRepeat = 2;

              };
              iCal."first day of week" = "Thursday";
              CustomUserPreferences = {
                NSGlobalDomain = {
                  AppleLocale = "de_DE";
                  AppleLanguages = [
                    "en-DE"
                    "de-DE"
                  ];
                };
                "com.apple.dock".region = "DE";
              };

            };
          };

          users.users.yusufraji = {
            name = "yusufraji";
            description = "Yusuf Raji";
            home = "/Users/yusufraji";
            isHidden = false;
            shell = null;
          };
          home-manager = {
            # On activation, move existing files by appending the given
            # file extension, rather that exiting with an error
            backupFileExtension = "backup";
          };
          users.users."yusufraji".packages = with pkgs; [ mob ];

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Yusufs-MacBook-Pro
      darwinConfigurations."Yusufs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yusufraji = import ./yusufraji_home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              # Apple Silicon Only; Also install Homebrew under the default Intel
              # prefix for Rosetta 2
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "yusufraji";
              # Automatically migrate existing Homebrew
              autoMigrate = true;

            };
          }
        ];
      };
      darwinPackages = self.darwinConfigurations."Yusufs-MacBook-Pro".pkgs;
    };
}
