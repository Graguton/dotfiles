{ config, pkgs, inputs, ... }:

let
  inputs_helix = inputs.helix.packages."${pkgs.system}";
  inputs_hyprland = inputs.hyprland.packages."${pkgs.system}"; # .hyprland
  inputs_anyrun = inputs.anyrun.packages."${pkgs.system}";
in
{
  imports = [ inputs.anyrun.homeManagerModules.default ];
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ethan";
  home.homeDirectory = "/home/ethan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dconf # for hyprland font and themes fix

    eww
    mako
    swww

    alacritty
    zellij

    inputs_helix.helix
    bottom
    ripgrep
    
    gnome-text-editor
    firefox    

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs = {
    git = { enable = true;
      userName = "Graguton";
      userEmail = "graguton@gmail.com";
      extraConfig = {
        core = {
          editor = "hx";
        };
        push = {
          default = "current";
        };
      };
      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        up = "pull --rebase";
      };
    };

    nushell = { enable = true;
    
    };

    starship = { enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[->](bold green)";
          error_symbol = "[->](bold red)";
        };
      };
    };
    
    anyrun = { enable = true;
      config = {
        plugins = [
          inputs_anyrun.applications
          inputs_anyrun.dictionary
          inputs_anyrun.kidex
          #inputs_anyrun.randr
          inputs_anyrun.rink
          inputs_anyrun.shell
          #inputs_anyrun.stdin
          inputs_anyrun.symbols
          inputs_anyrun.translate
          inputs_anyrun.websearch
        ];
        
        extraConfigFiles = ./config/anyrun;
      };
    };
  };
  
  wayland.windowManager.hyprland = { enable = true;
    package = inputs_hyprland.hyprland;
    xwayland.enable = true;
    systemd = { enable = true;
      variables = ["--all"];
    };
    extraConfig = builtins.readFile ./config/hyprland.conf;
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    #".config/hypr/hyprland.conf".source = config/hyprland.conf;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ethan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
