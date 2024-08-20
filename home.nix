{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ricol03";
  home.homeDirectory = "/home/ricol03";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ricol03/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  #home.globalVariables = {
    #PS1 = "\033[0;31mr";
  #};
  
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "/home/ricol03/yaml/tokyo-night-dark.yaml";
    image = /home/ricol03/Imagens/makoto.png;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    
    fonts = {
      monospace = {
        #package = pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "FiraCode" "DroidSansMono"];};
        #name = "FiraCode Nerd Font Mono";
        package = pkgs.source-code-pro;
        name = "Source Code Pro";
      };
      sansSerif = {
        package = pkgs.cantarell-fonts;
        name = "Cantarell";
      };
      serif = {
        package = pkgs.cantarell-fonts;
        name = "Cantarell";
      };
      sizes = {
        applications = 12;
        terminal = 1;
        desktop = 10;
        popups = 10;
      };
    };

    
  };
  
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      s = "sudo";
      nrsf = "nixos-rebuild switch --flake";
      hmsf = "home-manager switch --flake";
      clr = "clear";
      nf = "cd /home/ricol03/.nixfiles/";
    };
    bashrcExtra = ''
        eval "$(oh-my-posh init bash)"
	eval "$(direnv hook bash)"
      '';
  };

  programs.oh-my-posh = {
    enable = true;
    useTheme = "easy-term";
  };
 
  gtk = {
    enable = true;
    
    /*theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };*/
    #iconTheme.name = "papirus-icon-theme";
  };
  
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        #"geary.desktop"
        "vesktop.desktop"
  	"dev.geopjr.Tuba.desktop"
        "spotify.desktop"
        "org.gnome.Lollypop.desktop"
  	"de.haeckerfelix.Shortwave.desktop"
        "codium.desktop"
  	"obsidian.desktop"
  	"io.github.alainm23.planify.desktop"
      ];

      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Battery-Health-Charging@maniacx.github.com"
        "battery-indicator-icon@Deminder"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        #"custom-accent-colors@deminkp"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
        "kimpanel@kde.org"
        "logomenu@aryan_k"
        #"logowidget@github.com.howbea"
        #"nightthemeswitcher@romainvigier.fr"
        "mprisLabel@moon-0xff.github.com"
        "power-profile@fthx"
        "quick-settings-tweaks@qwreey"
        "runcat@kolesnikov.se"
        "simple-workspaces-bar@null-git"
        "transparent-window-moving@noobsai.github.com"
        
        #DOES NOT WORK CURRENTLY IN GNOME 46
        #"top-bar-organizer@julian.gse.jsts.xyz"
        
        #"uptime-indicator@gniourfgniourf.gmail.com"
        #"user-theme@gnome-shell-extensions-gcampax.github.com"
      ];
    };


    #GNOME configuration


    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      workspace-names = [ "P" "S" "S" "T" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>Z" ];
      switch-to-workspace-2 = [ "<Super>X" ];
      switch-to-workspace-3 = [ "<Super>C" ];
      switch-to-workspace-4 = [ "<Super>V" ];
    };

    #"org/gnome/desktop/background" = {
      #picture-uri = "https://rare-gallery.com/mocahbig/1353151-Nagisa-FurukawaClannad-HD-Wallpaper.jpg";
      #picture-uri-dark = "https://rare-gallery.com/mocahbig/1353151-Nagisa-FurukawaClannad-HD-Wallpaper.jpg";
    #};

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      show-battery-percentage = false;
    };
    
    "org/gnome/mutter" = {
      experimental-features = [ "variable-refresh-rate" ];
    };


    #Extensions configuration
    
    


   # "org/gnome/shell/extensions/logo-widget" = {
   #   logo-border = 90;
   #   logo-size = 10;
   #   logo-opacity = 100;
      #logo-file = "https://camo.githubusercontent.com/f64f62a9615a67a258497700904633ababef4ef24050472b5fdfcb341666ce2a/68747470733a2f2f692e696d6775722e636f6d2f793359646e62482e706e67";
      #logo-file-dark = "https://camo.githubusercontent.com/f64f62a9615a67a258497700904633ababef4ef24050472b5fdfcb341666ce2a/68747470733a2f2f692e696d6775722e636f6d2f793359646e62482e706e67";
   # };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      left-box-order = [ "simple-workspaces-bar" "uptime-indicator" "Media Controls" "Mpris Label"];
    };
    
    "org/gnome/shell/extensions/dash-to-dock" = {
      custom-theme-shrink = true;
      customize-alphas = true;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      max-alpha = 0.8;
      running-indicator-style = "DOTS";
      scroll-action = "cycle-windows";
      show-favorites = true;
      show-mounts = false;
      show-mounts-only-mounted = false;
      transparency-mode = "DYNAMIC";
    };

    # nightthemeswitcher
    /*"org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
      day = "adv-gtk3";
      enabled = true;
      night = "adv-gtk3-dark";
    };*/

    /*"org/gnome/shell/extensions/nightthemeswitcher/time" = {
      mainal-schedule = true;
      sunrise = 9;
      sunset = 20;
    };*/

    /*"org/gnome/shell/extensions/custom-accent-colors" = {
      accent-color = "orange";
      theme-flatpak = true;
      theme-gtk3 = true;
      theme-shell = true;
    };*/

  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  
}
