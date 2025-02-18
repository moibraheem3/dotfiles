{
  pkgs,
  username,
  ...
}: let
  inherit (import ./variables.nix) gitUsername gitEmail;
in {
  imports = [
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/tmux.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      GSK_RENDERER = "gl";
    };
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      # name = "Adwaita";
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      # package = pkgs.catppuccin-papirus-folders.override {
      #   flavor = "mocha";
      # rosewater maroon pink teal peach sapphire red
      # flamingo green mauve sky yellow blue lavender
      # accent = "green";
      # };
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      # gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adw-gtk3-dark";
    platformTheme.name = "gtk3";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "${gitUsername}";
      userEmail = "${gitEmail}";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    zsh = {
      enable = true;
      initExtra = ''
        source /home/${username}/dotfiles/configs/.zshrc
      '';
    };
    bash.enable = true;
    starship.enable = true;
  };

  services.blueman-applet.enable = true;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
