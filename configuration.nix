# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ seq, inputs, system, config, pkgs, lib, ... }:

/*let
  lagtrain = pkgs.stdenv.mkDerivation {
    pname = "lagtrain";
    version = "1.0";
    src = pkgs.fetchurl {
      url = "https://github.com/ricol03/lagtrain-plymouth-theme/releases/download/Pre-release/lagtrain.tar.gz";
      sha256 = "39f0a7dee608bce3c7b2339dca88e7cde0925737e8b4f2b1c3a9c5ade6410970"; # Replace with the actual SHA-256 hash
    };
    nativeBuildInputs = [ pkgs.libarchive ];  # Ensure necessary tools are available
    unpackPhase = ''
      tar xvf $src --strip-components=1
    '';
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/lagtrain
      cp -r . $out/share/plymouth/themes/lagtrain
    '';
    meta = with pkgs.lib; {
      description = "Lagtrain Plymouth Theme";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ricol03 ];
    };
  };
in*/

{ 

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  specialisation = {
    vmware = {
      inheritParentConfig = true;
      configuration = {
      
        services.xserver.desktopManager.plasma6.enable = true;
        programs.ssh.askPassword = lib.mkForce "yes";
    
        boot.kernelPackages = lib.mkForce (pkgs.linuxPackages.extend (self: super: {
          kernel = pkgs.linuxKernel.kernels.linux_6_8;
        }));
      
        environment.systemPackages = [
          inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        ];
    
        virtualisation.vmware.host = {
          enable = true;
          /*package = pkgs.vmware-workstation.overrideAttrs {
            src = pkgs.fetchurl {
              url = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.5.1/23298084/linux/core/VMware-Workstation-17.5.1-23298084.x86_64.bundle.tar";
              hash = "sha256-4kA5zi9roCOHWSpHwEsRehzrlAgrm/lugSLpznPIYRw=";
            };
          }*/
        };
      };
    };
  };

  
 /*nixpkgs.overlays = [
    (self: super: {
      vmware-workstation = super.vmware-workstation.overrideAttrs (vself: vsuper:
        let
          urlBase = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.5.1/23298084/linux/";
          file = "VMware-Workstation-17.5.1-23298084.x86_64.bundle";
        in
        {
          src = "${self.fetchzip {
      url = urlBase + "core/${file}.tar";
      hash = "sha256-5PZZpXN/V687TXjqeTm8MEays4/QTf02jVfdpi9C7GI=";
      stripRoot=false;
    }}/${file}";
          unpackPhase =
            let
              vmware-unpack-env = self.buildFHSEnv {
                name = "vmware-unpack-env";
                targetPkgs = pkgs: [ self.zlib ];
              };
              vmware-tools =
                let
                  version = "12.3.5";
                  build = "2254409";
                  file = system: "vmware-tools-${system}-${version}-${build}.x86_64.component";
                  hashes = {
                    linux = "sha256-vT08mR6cCXZjiQgb9jy+MaqYzS0hFbNUM7xGAHIJ8Ao=";
                    linuxPreGlibc25 = "sha256-BodN1lxuhxyLlxIQSlVhGKItJ10VPlti/sEyxcRF2SA=";
                    netware = "sha256-o/S4wAYLR782Fn20fTQ871+rzsa1twnAxb9laV16XIk=";
                    solaris = "sha256-3LdFoI4TD5zxlohDGR3DRGbF6jwDZAoSMEpHWU4vSGU=";
                    winPre2k = "sha256-+QcvWfY3aCDxUwAfSuj7Wf9sxIO+ztWBrRolMim8Dfw=";
                    winPreVista = "sha256-3NgO/GdRFTpKNo45TMet0msjzxduuoF4nVLtnOUTHUA=";
                    windows = "sha256-2F7UPjNvtibmWAJxpB8IOnol12aMOGMy+403WeCTXw8=";
                  };
                  srcs = map
                    (system:
                      "${self.fetchzip {
            url = urlBase + "packages/${file system}.tar";
            hash = hashes.${system};
            stripRoot=false;
          }}/${file system}"
                    )
                    (builtins.attrNames hashes);
                in
                lib.concatMapStringsSep " " (src: "--install-component ${src}") srcs;
            in
            ''
              ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${vself.src} ${vmware-tools} --extract unpacked"
            '';
        });
    })
  ];*/
  
/* nixpkgs.overlays = [ (self: super: {
  vmware-workstation = super.vmware-workstation.overrideAttrs (vself: vsuper:
  let
    urlBase = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.5.1/23298084/linux/";
    file = "VMware-Workstation-17.5.1-23298084.x86_64.bundle";
  in {
    src = "${self.fetchzip {
      url = urlBase + "core/${file}.tar";
      hash = "sha256-nYkqZ7w3AYdw2YvQNATIYeJpqUwmkLE6jzyQlhGKyEs=";
      stripRoot=false;
    }}/${file}";
    unpackPhase =
    let
      vmware-unpack-env = self.buildFHSEnv {
        name = "vmware-unpack-env";
        targetPkgs = pkgs: [ self.zlib ];
      };
      vmware-tools =
      let
        version = "12.3.5";
        build = "22544099";
        file = system: "vmware-tools-${system}-${version}-${build}.x86_64.component";
        hashes = {
          linux = "sha256-VHFc2g9Bpz7RaJDTB+MXZ2VKe6YfcM1Y2qcqL75mOgw=";
          linuxPreGlibc25 = "sha256-ubxS82tyY/biGSBPvPFsggKLYRXUMVJU9dqNfILa7OY=";
          netware = "sha256-Fs+R4RTgbV+SlFuz7DO/NXdqfMMXf05eSmIfD8AWjvI=";
          solaris = "sha256-HajtvDG/iPUmi7clO2wkSQRMWsOI/rLFHVDlw/vL4wI=";
          winPre2k = "sha256-lX4uvJRFSUIzm6cxCCuZwrsgPuRE2Wr1+GYFY0Qk8Tw=";
          winPreVista = "sha256-xA3UvxIS7u435T0LsyMTCHFUZL9dkTXuekXexOWkXRc=";
          windows = "sha256-/UrzEQTBhmuQODnNoNPQD4pI4MNCxordb/FxVPS3A9o=";
        };
        srcs = map (system:
          "${self.fetchzip {
            url = urlBase + "packages/${file system}.tar";
            hash = hashes.${system};
            stripRoot=false;
          }}/${file system}"
        ) (builtins.attrNames hashes);
      in
        lib.concatMapStringsSep " " (src: "--install-component ${src}") srcs;
    in ''
      ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${vself.src} ${vmware-tools} --extract unpacked"
    '';
  });
})];*/

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #inputs.nixpkgs-vmware.config.allowUnfree = true;
  
  boot.kernelParams = [ ];
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxKernel.kernels.linux_6_8;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages.extend (self: super: {
    #kernel = pkgs.linuxKernel.kernels.linux_6_8;
  #});

  
  boot.loader.systemd-boot.enable = true;
  #boot.loader.refind.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  #boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    theme = "lagtrain";
    themePackages = [ inputs.lagtrain.packages.x86_64-linux.default ];
    
    #theme = "bowlbird-logo";
    #themePackages = [ inputs.test.packages.x86_64-linux.default ];
    
  };
 
  boot.supportedFilesystems = [ "ntfs" ];

  #boot.resumeDevice = "/dev/disk/by-uuid/ee3f25b2-45c9-4c1d-bde3-c2b3fca335bf/";

  #systemd.sleep.extraConfig = ''
  #  AllowSuspend=yes
  #  AllowHibernation=yes
  #'';

  networking.hostName = "NixOS-PC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.samba = {
    enable = true;
    enableWinbindd = true;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mysql";
  };
  
  services.fwupd = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  #programs.openvpn3.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable bluetooth
  #hardware.bluetooth.enable = true;

  # Virtualbox enablement
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ricol03" ];

  virtualisation.libvirtd.enable = true;
  
  programs.virt-manager.enable = true;

  /*virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation.overrideAttrs {
      src = pkgs.fetchurl {
        url = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.5.1/23298084/linux/core/VMware-Workstation-17.5.1-23298084.x86_64.bundle.tar";
        hash = "sha256-4kA5zi9roCOHWSpHwEsRehzrlAgrm/lugSLpznPIYRw=";
      };
    }
  };*/
  
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    enableTCPIP = true;
  };


  # OpenRGB Server
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    # deprecated: driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  #"nvidia"

  hardware.openrazer = {
    enable = true;
    users = [ "ricol03" ]; 
  };
  #hardware.amdgpu = {
  #  amdvlk = true;
  #  opencl = true;
  #};

  services.supergfxd.enable = true;
  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      #sync.enable = true;
      reverseSync.enable = true; 
      offload = {  
            enable = true;
            enableOffloadCmd = true;
      };
    
	# Make sure to use the correct Bus ID values for your system!
      amdgpuBusId = "PCI:53:0:0";
      nvidiaBusId = "PCI:01:0:0";
    };
  };
  
  #programs.coolercontrol.enable = true;
  #programs.coolercontrol.nvidiaSupport = true;
  
  #programs.corectrl.enable = true;
  
  #services.ratbagd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_PT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };
  
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    pkgs.fcitx5-mozc
    pkgs.fcitx5-gtk
    pkgs.fcitx5-configtool
  ];

  programs.direnv.enable = true;

  #fonts.fonts = with pkgs; [
    #carlito
    #dejavu_fonts
    #ipafont
    #kochi-substitute
    #source-code-pro
    #ttf_bitstream_vera
  #];

  #fonts.fontconfig.ultimate.enable = true;
  
  # Enable flatpak support.
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  #services.xserver.desktopManager.pantheon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "pt";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # recently been deprecated
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ricol03 = {
    isNormalUser = true;
    description = "ricol03";
    extraGroups = [ "mysql" "networkmanager" "wheel" "wireshark" "adbusers" ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  
  programs.gamemode.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.npm = {
    enable = true;
  };
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages

  ];
  
  programs.adb.enable = true;
  
  # Card reader service
  services.pcscd.enable = true;

  #services.xrdp.enable = true;
  
  /*environment.libraries = with pkgs;[
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl
    libsoup
    librsvg
    pango
    libayatana-appindicator
  ];*/


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # Programs
     alsa-lib
     #bottles
     ciscoPacketTracer8
     #cool-retro-term
     #davinci-resolve
     dbeaver-bin
     #dotnet-sdk
     duckstation
     #envycontrol.packages.x86_64-linux.default
     firefox
     freepats
     gimp
     google-chrome
     gnome-extension-manager
     gnome-firmware
     
     #gnome.dconf-editor
     gnome.gnome-software
     gnome.gnome-remote-desktop
     gnome-tweaks
     #gradience
     gzdoom
     home-manager
     komikku
     #jetbrains.idea-community
     #jetbrains.clion
     #jetbrains.rider
     libreoffice
     lollypop
     lutris
     miru
     menulibre
     #mysql
     mono
     newsflash
     obs-studio
     obsidian
     oh-my-posh
     openjdk21
     openrazer-daemon
     openrgb
     #openvpn
     osu-lazer-bin
     pcsx2
     planify
     #polychromatic
     #poetry
     #piper
     postgresql
     postman
     #pgadmin4-desktopmode
     protontricks
     ppsspp
     qemu
     resources
     #razergenie
     shortwave
     #staruml
     #sticky
     #tigervnc
     timidity
     thunderbird
     tuba
     variety
     vesktop
     #vlc
     vscodium-fhs
     wireshark
     #zoom-us
  # CLI Tools
     afetch
     appimage-run
     btop
     #busybox
     #cargo
     #ccid
     cmake
     #curl
     #curlWithGnuTls
     dconf
     distrobox
     fontconfig
     glib
     glibc
     git
     glxinfo
     #gnumake
     #htop
     inetutils
     libheif
     libpcap
     libglibutil
     #libuuid
     lttng-ust
     meson
     mplayer
     nerdfonts
     nh
     #ninja
     openrazer-daemon
     openssl
     #pcsclite
     pciutils
     pkg-config
     screenfetch
     qadwaitadecorations
     qadwaitadecorations-qt6
     qgnomeplatform
     #wayvnc
  # Gnome Extensions and personalization
     gnomeExtensions.dash-to-dock
     gnomeExtensions.appindicator
     gnomeExtensions.battery-health-charging
     gnomeExtensions.battery-indicator-icon
     gnomeExtensions.blur-my-shell
     gnomeExtensions.caffeine
     gnomeExtensions.clipboard-indicator
     #gnomeExtensions.custom-accent-colors
     gnomeExtensions.gsconnect
     gnomeExtensions.just-perfection
     gnomeExtensions.kimpanel
     gnomeExtensions.logo-menu
     gnomeExtensions.mpris-label
     gnomeExtensions.night-theme-switcher
     #gnomeExtensions.panel-corners
     gnomeExtensions.power-profile-indicator-2
     gnomeExtensions.quick-settings-tweaker
     gnomeExtensions.runcat
     gnomeExtensions.top-bar-organizer
     gnomeExtensions.transparent-window-moving
     gnomeExtensions.uptime-indicator
     #beauty-line-icon-theme
     #marwaita
     #luna-icons
     #cosmic-icons
     nixos-icons
     #zafiro-icons
     #oxygen-icons5
     #tela-circle-icon-theme
     #gnome.adwaita-icon-theme
  # QT theme configuration
     qt5Full
     #libsForQt5.qt5ct
     libsForQt5.qtstyleplugin-kvantum
     adwaita-qt
     #kvantum
  # Wine
     wineWowPackages.stable
     winetricks
     nodejs
     nodePackages.vercel 
  # Pitão
     python312Packages.python
     #python311Packages.conda
     #virtualenv
  # Dotnet
     mono
     msbuild
  # Touhou On NixOS
     inputs.touhou-on-nixos.packages.x86_64-linux.thcrap2nix
     inputs.nix-touhou.packages.x86_64-linux.default
  # Catppuccinifier
     #inputs.catppuccinifier.packages.${pkgs.system}.cli
  # VMware modules
     #vmware-workstation
     #
     #pkgs.linuxKernel.packages.linux_6_9.virtualbox
  ];
  
  nixpkgs.config.permittedInsecurePackages = [
     "python3.12-youtube-dl-2021.12.17"
  ];


  environment.sessionVariables = {
    FLAKE="/home/ricol03/.nixfiles";
    QT_QPA_PLATFORM="wayland";
    QT_QPA_PLATFORMTHEME="qt5ct";
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.libuuid]}";
  };
  
  qt.enable = true;
  #qt.platformTheme = "qt5ct";
  
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "/home/ricol03/yaml/tokyo-night-dark.yaml";
    image = /home/ricol03/Imagens/makoto.png;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    targets.gnome.enable = true;
    targets.gtk.enable = true;
    targets.plymouth.enable = false;
  };
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Currently doesn't work (for some reason)
  systemd.services.bootsound = {
    enable = true;
    description = "bootup sound";
    wants = ["sound.target"];
    #after = ["sound.target"];
    wantedBy = ["graphical.target"];
    serviceConfig = {
      Type = "oneshot";
      #Environment="XDG_RUNTIME_DIR=/run/user/1000 Environment=PULSE_RUNTIME_PATH=/run/user/1000/pulse/";
      ExecStart = "/run/current-system/sw/bin/aplay /home/ricol03/Música/quadra.wav";
      RemainAfterExit = false;
    };
  };
  
  #suggestion by nebucatnetzer on Mastodon to solve responsiveness during updates
  nix.daemonCPUSchedPolicy = "idle";

  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-unstable";

  system.stateVersion = "unstable"; 
}
