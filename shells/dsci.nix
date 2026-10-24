{ pkgs, ... }:

{
  buildInputs = builtins.attrValues {
    inherit (pkgs) python314;
    inherit (pkgs.python314Packages)
      # keep-sorted start
      fastparquet
      marimo
      matplotlib
      numpy
      pandas
      pip
      polars
      python-lsp-server
      rich
      scikit-learn
      seaborn
      sympy
      tqdm
      # keep-sorted end
      ;
  };
}
