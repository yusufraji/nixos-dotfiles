{ pkgs }:
{
  enable = true;
  package = pkgs.git;

  userName = "yusufraji";

  userEmail = "raji.yusuf234@gmail.com";

  aliases = {
    s = "status";
    d = "diff";
    co = "checkout";
    br = "branch";
    last = "log -1 HEAD";
    cane = "commit --amend --no-edit";
    cm = "commit -m";
    sc = "switch -c";
    lo = "log --online -n 10";

    staash = "stash --all";

  };

  signing = {
    key = null;
    signByDefault = false;
  };

  delta = {
    enable = true;
    #   options = {
    #     # navigate = true;
    #     # dark = true;
    #   };
  };
  extraConfig = {
    user = {
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMejrpUg404m7rj+96mTRd83TbVLQxCnYFsHeTMfobNV raji.yusuf234@gmail.com";
    };
    gpg = {
      format = "ssh";
    };
    core = {
      # Treats spaces before tabs and all kinds of trailing whitespaces as an error.
      whitespace = "space-before-tab, trailing-space, tabwidth = 4";

      # Make `git rebase` safer on MacOS.
      trustctime = false;

      # Prevent showing files whose names contain non-ASCII symbols as unversioned.
      precomposeunicode = false;

      # Speed up commands involving untracked files such as `git status`.
      untrackedCache = true;

      # pager = "delta";
    };

    color = {
      ui = "always";
      advice = "always";
    };
    diff = {
      # algorithm = "historgram";
      mnemonicPrefix = true;
      colorMoved = "default";
    };
    help = {
      autocorrect = 1;
    };
    init = {
      defaultBranch = "main";
    };
    merge = {
      confilicstyle = "zdiff3";
      branchdesc = true;
      log = true;
      renames = true;
      directoryRenames = true;
    };
    pull = {
      rebase = true;
    };
    push = {
      default = "simple";
      gpgSign = "if-asked";
    };
    rerere = {
      enable = true;
    };
  };

}
