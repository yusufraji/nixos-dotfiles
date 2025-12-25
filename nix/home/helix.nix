{ pkgs }:
{
  enable = true;
  package = pkgs.helix;
  settings = {
    theme = "my_gruv";
    editor = {
      line-number = "relative";
      cursorline = true;
      cursorcolumn = true;
      mouse = false;
      bufferline = "always";
      auto-completion = true;
      auto-format = true;
      text-width = 80;
      color-modes = true;
      end-of-line-diagnostics = "warning";
      popup-border = "all";
      autosave = {
        after-delay.enable = true;
        after-delay.timeout = 1000;
      };
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      lsp = {
        enable = true;
        auto-signature-help = true;
        display-messages = true;
        display-inlay-hints = true;

      };
      indent-guides = {
        render = true;

      };

      soft-wrap = {
        enable = true;
        max-wrap = 25; # increase value to reduce forced mid-word wrapping
        max-indent-retain = 0;
        wrap-indicator = ""; # set wrap-indicator to "" to hide it
      };
      whitespace = {
        render = "all";

        characters = {
          space = ".";
          nbsp = "⍽";
          nnbsp = "␣";
          tab = "→";
          newline = "⏎";
          tabpad = "·"; # Tabs will look like "→···" (depending on tab width)
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "hint";
        };
        statusline = {
          right = [
            "workspace-diagnostics"
            "diagnostics"
            "selections"
            "register"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];

        };

      };

    };
    keys = {
      normal = {
        # ref https://youtu.be/p3qvSz4RJts?si=aldlo2irULjPYa3q
        C-g = [
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
        ];
        C-l = ":open ~/.config/helix/languages.toml";

        space = {
          o = ":open ~/.config/helix/snippets"; # Open code snippet

        };
      };
    };
  };
  languages = [ ];
  themes = {
    my_gruv = {
      inherits = "gruvbox_dark_soft";

      ui.cursorline.primary = {
        bg = "#000000";
      };

    };
  };
}
