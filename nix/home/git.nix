{ pkgs }:
{
  enable = true;
  package = pkgs.git;

  signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMejrpUg404m7rj+96mTRd83TbVLQxCnYFsHeTMfobNV raji.yusuf234@gmail.com";
    signByDefault = true;
  };

  # delta = {
  #   enable = true;
  #   #   options = {
  #   #     # navigate = true;
  #   #     # dark = true;
  #   #   };
  # };
  settings = {
    user = {
      name = "yusufraji";
      email = "raji.yusuf234@gmail.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMejrpUg404m7rj+96mTRd83TbVLQxCnYFsHeTMfobNV raji.yusuf234@gmail.com";
    };
    alias = {
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
    gpg = {
      format = "ssh";
      ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
      autoSetupRemote = true;
    };
    rerere = {
      enable = true;
    };
  };

}
