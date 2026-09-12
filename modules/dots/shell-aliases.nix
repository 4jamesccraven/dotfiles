{ ... }:

{
  home-manager.users.jamescraven.home = {
    shellAliases = {
      # :> System Justfile
      nx = "just --justfile /home/jamescraven/nixos/justfile";

      # :> Abbreviations
      # keep-sorted start
      c = "clear";
      cff = "clear; fastfetch";
      ff = "fastfetch";
      j = "just";
      s = "kitten ssh";
      y = "yazi";
      # keep-sorted end

      # :> Git
      # keep-sorted start
      ga = "git add . --all";
      gb = "git branch";
      gc = "git clone";
      gcm = "git commit";
      gco = "git checkout";
      gd = "git diff HEAD";
      gf = "git fetch";
      gfp = "git fetch --prune";
      ggr = "cd $(git rev-parse --show-toplevel)";
      gi = "git init";
      gl = "git log --stat";
      gp = "git push origin HEAD";
      gr = "git rev-parse --show-toplevel";
      gs = "git status";
      gu = "git pull";
      # keep-sorted end
      gitaliases = "alias | grep git | grep -v gitaliases | sed 's/ *= */ = /' | column -t -s=";

      # :> Tools
      # keep-sorted start
      nohist = "HISTFILE= bash";
      pcalc = "nix develop $HOME/nixos#dsci -c python";
      # keep-sorted end
    };
  };
}
