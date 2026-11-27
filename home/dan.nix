{ config, pkgs, ... }:

{
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # don't change this:
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fastfetch
    bat
    age
    ansible
    kubectl
    talosctl
    k9s
    claude-code
    sops
    kubectx
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # FISH
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-desktop-config/";
      rebuild-boot = "sudo nixos-rebuild boot --flake ~/nixos-desktop-config/";
      update = "nix flake update --flake ~/nixos-desktop-config/";
      k = "kubectl";
    };
    interactiveShellInit = ''
      set -g fish_greeting
      if not set -q tide_left_prompt_items
        tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='12-hour format' \
          --rainbow_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Sharp \
          --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Disconnected \
          --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Dark \
          --prompt_spacing=Compact --icons='Many icons' --transient=Yes
      end
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  # GIT
  programs.git = {
    enable = true;
    settings = {
      user.name = "Dan Fedele";
      user.email = "dan.fedele@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set mouse=
      set nocompatible
      set tabstop=4
      set softtabstop=4
      set expandtab
      set shiftwidth=4
      set autoindent
      syntax on
      set ttyfast
      set nu
      '';
  };

  # Kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    keybindings = {
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+t" = "new_tab --cwd=current";
      "ctrl+shift+z" = "toggle_layout stack";
    };
  };  

  # Sensitive files
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets.kubeconfig = {
      sopsFile = ../secrets/kubeconfig;
      format = "binary"; # whole file
      path = "${config.home.homeDirectory}/.kube/config";
      mode = "0600";
    };

    secrets.talosconfig = {
      sopsFile = ../secrets/talosconfig;
      format = "binary";
      path = "${config.home.homeDirectory}/.talos/config";
      mode = "0600";
    };
  };
}
