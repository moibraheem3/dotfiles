# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  host,
  username,
  lib,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./users.nix
    ./hardware-configuration.nix
    ../../modules/nixos/nivdia.nix
    ../../modules/nixos/nivdia-prime.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  #  boot.loader.grub.enable = true;
  #  boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.supportedFilesystems = ["ntfs"];
  boot.supportedFilesystems = {
    btrfs = true;
    ntfs = true;
  };
  virtualisation.docker.enable = true;

  services.fstrim.enable = lib.mkDefault true;
  # Gnome 40 introduced a new way of managing power, without tlp.
  # However, these 2 services clash when enabled simultaneously.
  # https://github.com/NixOS/nixos-hardware/issues/260
  services.tlp.enable =
    lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
      || !config.services.power-profiles-daemon.enable);
  # Hard disk protection if the laptop falls:
  services.hdapsd.enable = lib.mkDefault true;

  networking.hostName = host;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    FLAKE = "/home/${username}/dotfiles/";
    NH_FLAKE = "/home/${username}/dotfiles/";
  };

  # Set your time zone.
  time.timeZone = "Africa/Cairo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_EG.UTF-8";
    LC_IDENTIFICATION = "ar_EG.UTF-8";
    LC_MEASUREMENT = "ar_EG.UTF-8";
    LC_MONETARY = "ar_EG.UTF-8";
    LC_NAME = "ar_EG.UTF-8";
    LC_NUMERIC = "ar_EG.UTF-8";
    LC_PAPER = "ar_EG.UTF-8";
    LC_TELEPHONE = "ar_EG.UTF-8";
    LC_TIME = "ar_EG.UTF-8";
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Bluetooth Support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;

    extraConfig = {
      pipewire = {
        "91-null-sinks" = {
          "context.objects" = [
            {
              # A default dummy driver. This handles nodes marked with the "node.always-driver"
              # properyty when no other driver is currently active. JACK clients need this.
              factory = "spa-node-factory";
              args = {
                "factory.name" = "support.node.driver";
                "node.name" = "Dummy-Driver";
                "priority.driver" = 8000;
              };
            }
            {
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "Microphone-Proxy";
                "node.description" = "Microphone";
                "media.class" = "Audio/Source/Virtual";
                "audio.position" = "MONO";
              };
            }
            {
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "Main-Output-Proxy";
                "node.description" = "Main Output";
                "media.class" = "Audio/Sink";
                "audio.position" = "FL,FR";
              };
            }
          ];
        };
      };
      pipewire-pulse = {
        "92-low-latency" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {};
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = "32/48000";
            "pulse.default.req" = "32/48000";
            "pulse.max.req" = "32/48000";
            "pulse.min.quantum" = "32/48000";
            "pulse.max.quantum" = "32/48000";
          };
          "stream.properties" = {
            "node.latency" = "32/48000";
            "resample.quality" = 1;
          };
        };
      };
    };

    wireplumber.extraConfig = {
      "99-disable-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_input.*";
              }
              {
                "node.name" = "alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };

  services.gvfs.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      xwayland.enable = true;
    };
    waybar.enable = true;
    xwayland.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            libxkbcommon
          ];
      };
    };
    gamemode.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (
              subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
             )
          {
            return polkit.Result.YES;
          }
      })
    '';
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    lazygit
    fzf
    stow
    slack
    brave
    dbeaver-bin
    zip
    postman
    curl
    gnutar
    unzip
    # inputs.ghostty.packages.x86_64-linux.default
    libreoffice-qt6
    wine
    wine64
    winetricks
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
        pkgs.mangohud
      ];
    })
    thunderbird
    kitty
    quickshell

    # jetbrains.idea
    # jetbrains.idea-community
    obsidian
    markdown-oxide

    nh
    eza
    bat

    # Gnome
    nautilus
    file-roller
    loupe
    evince
    polkit_gnome

    killall
    wget
    tuigreet
    hyprpaper
    hyprlock
    hypridle
    pavucontrol
    grim
    slurp
    swappy
    wl-clipboard
    wlogout
    pywal16
    imagemagick
    networkmanagerapplet
    brightnessctl
    playerctl
    swaynotificationcenter

    btop
    libnotify
    adw-gtk3
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
  ];

  # Cachix, Optimization settings and garbage collection automation
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.fira-code
      vazir-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      font-awesome
      symbola
      material-icons
      jetbrains-mono
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
