{
  description = "Nix-Darwin systems and tools by yusuf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      mac-app-util,
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
            ollama
            # open-webui
            rage
            age-plugin-yubikey
            btop
            htop
          ];
          environment.variables = {
            EDITOR = "hx";
            VISUAL = "hx";
            LANG = locale;
            LC_ALL = locale;
            HOMEBREW_CASK_OPTS = "--no-quarantine";
          };

          # Allows getting completion for system packages (e.g. systemd).
          environment.pathsToLink = [
            "/usr/share/zsh"
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.warn-dirty = false;
          nix.settings = {
            # extra-platforms = [
            #   "x86_64-linux"
            #   "i86-linux"
            # ];

            trusted-users = [
              "@admin"
              "yusufraji"
            ];
          };

          # Enable building nixos images & also remote deploy to Linux
          # systems (nixos) without the need for external remote builders.
          # This helps when using colmena.
          # Ref: https://nixcademy.com/posts/macos-linux-builder/
          nix.linux-builder = {
            enable = true;
            ephemeral = true;
            systems = [
              "aarch64-linux"
              "x86_64-linux"
            ];
            maxJobs = 4;
            config = {
              boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
              virtualisation = {
                darwin-builder = {
                  diskSize = 40 * 1024;
                  memorySize = 8 * 1024;
                };
                cores = 6;
              };
            };
          };

          # Automatic cleanup
          nix = {
            gc = {
              automatic = true;
              interval = {
                Weekday = 0;
                Hour = 3;
                Minute = 0;
              };
              options = "--delete-older-than 10d";
            };
          };
          nix.optimise.automatic = true;

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          programs.zsh.enable = true;
          programs.zsh.enableCompletion = false;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          nixpkgs.config = {
            # allowBroken = true;
            allowUnfree = true;
          };
          # services.open-webui.enable = true;
          # launchd.agents.open-webui.serviceConfig = {
          #   ProgramArguments = [ "${pkgs.open-webui}/bin/open-webui" ];
          #   EnvironmentVariables.OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          #   RunAtLoad = true;
          #   KeepAlive = true;
          # };

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
            ibm-plex
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
            # file extension, rather than exiting with an error
            backupFileExtension = "backup";
          };
          users.users."yusufraji".packages = with pkgs; [
            mob
            # orbstack
          ];

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Yusufs-MacBook-Pro
      darwinConfigurations."Yusufs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # On activation, move existing files by appending the given
            # file extension, rather than exiting with an error
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
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
          {
            homebrew = {
              enable = true;
              taps = [
                "nikitabobko/tap"
              ];
              brews = [
                "act"
                "arm-none-eabi-gdb"
                "autoconf"
                "bat"
                "c-ares"
                "coreutils"
                "dbus"
                "docker"
                "docker-completion"
                "docker-machine"
                "dotnet@8"
                "fd"
                "ffmpeg"
                "flac"
                "fzf"
                "gd"
                "gibo"
                "git"
                "gnupg"
                "graphviz"
                "helix"
                "imagemagick"
                "jq"
                "krb5"
                "lazygit"
                "libgit2"
                "llvm"
                "lua"
                "m4"
                "ncurses"
                "node"
                "openjdk"
                "pandoc"
                "pinentry"
                "pkgconf"
                "pre-commit"
                "protobuf"
                "pyenv"
                "pyenv-virtualenv"
                "python@3.11"
                "python@3.13"
                "ripgrep"
                "sqlite"
                "telnet"
                "tree"
                "unbound"
                "virtualenv"
                "wget"
                "zellij"
              ];
              casks = [
                "aerospace"
                "alacritty"
                "amethyst"
                "dbeaver-community"
                "db-browser-for-sqlite"
                # "emacs"
                "emacs-app"
                "ghostty"
                "iterm2"
                "libreoffice"
                "rar"
                "tigervnc"

                "visual-studio-code"
                "wezterm"
                "font-symbols-only-nerd-font"
                # "tigervnc-viewer"
                "chromium"
              ];

              onActivation = {
                autoUpdate = false;
                cleanup = "zap";
                # cleanup = "none";
              };
            };
          }
        ];
      };
      darwinPackages = self.darwinConfigurations."Yusufs-MacBook-Pro".pkgs;
    };
}
