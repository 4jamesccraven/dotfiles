{ pkgs, ... }:

{
  buildInputs = builtins.attrValues {
    inherit (pkgs)
      cargo
      libgcc
      rustc
      ;
  };
}
