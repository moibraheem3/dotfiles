{
  pkgs,
  inputs,
  system,
  ...
}: let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.neovim;
in {
  # xdg.configFile.nvim = {
  #   source = ../../configs/.config/nvim;
  #   recursive = true;
  # };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = neovim-nightly;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc
      alejandra
      stylua
      prettierd
      nixd
      lua-language-server
      tree-sitter
    ];
  };
}
