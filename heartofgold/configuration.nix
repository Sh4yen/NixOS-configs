# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
# Arguments used to evaluate the config
{ config, pkgs, ... }:

let
  user="shayen";
in
{
  # give this config a label
  system.nixos.tags = ["removed_electron_onenote"];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  # automate garbage collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  
  # Use the systemd-boot EFI boot loader.  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  

  #enable ntfs file system 
  boot.supportedFilesystems = [ "ntfs" ];

  # networking
  networking.hostName = "heartofgold"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings =  {
    LC_LANGUAGE = "en_US.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONATARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };
  
  #Configure console Keymap
  console.keyMap = "de";

  # Sound
  sound.enable = true;
  sound.mediaKeys.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };	 

  # define window manager
  programs.hyprland.enable = true;
  
  # OpenGL/CL and Vulkan support
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
  rocm-opencl-icd
  rocm-opencl-runtime
  amdvlk
  driversi686Linux.amdvlk	# add vulkan support for 32-bit applications
  ];

  # Vulkan Support
  hardware.opengl.driSupport = true;

  # Force radv (graphics card driver)
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp" "scanner"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # configure pfetch
  environment.variables = {
    PF_INFO="ascii";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget  # http/s, ftp, file grabber
    kitty
    dunst
    libnotify
    xdg-desktop-portal-hyprland
    firefox
    tree
    vscode
    sl
    hyprpaper  # wallpaper
    spotify
    steam
    wofi  # launcher
    pfetch  # like neofetch
    nerdfonts
    git
    waybar
    hyprpicker  # color picker
    feh  # image viewer
    signal-desktop
    simple-mtpfs  # phone file transfare
    pcmanfm  # file manager 
    vlc
    yt-dlp  # yt-dl fork
    obsidian
    nextcloud-client
    freetube
    bitwarden
    grim  # grabs images for screenshots
    slurp  # select border for screenshots
    wl-clipboard  # ctr+c and ctr+v used for screenshots
    libreoffice
    wineWowPackages.waylandFull
    gimp-with-plugins  # image manipulation tool
    nomacs  # image viewer
    picard  # music tagger
    gnome.seahorse  # keyring gui
    libsForQt5.polkit-kde-agent
    polkit_gnome
    microsoft-edge
  ];


  # enable steam 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Enable tailscale
  services.tailscale.enable = true;
  services.gvfs.enable = true;
  # Enables the polkit authentification agent, propts sudo password when using gui programms
  security.polkit.enable = true;  
  # enable flatpak
  services.flatpak.enable = true;  
  # configure keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;


  # Open ports in the firewall.	
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # keep copy of last configuration.nix in /run/current-system/configuration.nix
  system.copySystemConfiguration = true;



  
}

