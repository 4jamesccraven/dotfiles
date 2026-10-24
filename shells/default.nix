{ pkgs, ... }:

{
  buildInputs = builtins.attrValues {
    inherit (pkgs)
      nh
      just
      git
      ;
  };
}
