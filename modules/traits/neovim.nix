{ inputs, pkgs, ... }:

/*
  ====[ Neovim ]====
  :: trait

  Neovim, my goat <3

  Enables:
    :> User Level
    aliases => symlinks vi{,m} to nvim
    lsp     => installs a bunch of lsps referenced by my config
    config  => symlinks my config from ../dots/neovim
*/
{
  environment = {
    sessionVariables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      # :> LSP
      bash-language-server
      clang-tools
      lua-language-server
      nixd
      nixfmt
      pyright
      rust-analyzer
      rustfmt
      tinymist

      # :> etc.
      gcc
      # inputs.tree-sitter.packages.${pkgs.stdenv.hostPlatform.system}.default
      tree-sitter
      websocat
      wl-clipboard
      xclip
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = true;
  };

  home-manager.users.jamescraven =
    { config, ... }:
    let
      inherit (config.home) homeDirectory;
    in
    {
      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/modules/dots/neovim";
    };
}
