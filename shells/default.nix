{ pkgs, ... }:

{
  buildInputs = with pkgs; [
    nh
    just
    git
  ];
}
