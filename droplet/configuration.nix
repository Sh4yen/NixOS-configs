# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
# test 123
{ config, pkgs, ... }:

{
  # give this config a label
  system.nixos.tags = ["deleted_statefull_data_having_a_noter_go_at_pgsql"];

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

  networking.hostName = "droplet"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  # Configure console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shayen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    tree
    wget
    git
    neofetch
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  # Enable tailscale
    services.tailscale.enable = true;
  

  # Enable the nextcloud server
  environment.etc."nextcloud-admin-pass".text = "#v6EfNV63T";
  services.nextcloud = {
    enable = true; 
    package = pkgs.nextcloud27;
    hostName = "droplet";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/etc/nextcloud-admin-pass";
      defaultPhoneRegion = "DE";
    };
    # redis performant caching backend -> faster page loading
    configureRedis = true;
    # enable https encryption
    https = true;
    # change max upload file size
    maxUploadSize = "128G";
    phpOptions = {
      upload_max_filesize = "128G";
      post_max_size = "128G";
    };
  };

  # get https certs and force Secure Sockets Layer
  services.nginx.virtualHosts.droplet  = {
    forceSSL = true;
    enableACME = true;
  };
  
  # accept lets encrypts TOS
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "marxloui@protonmail.com";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
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

}
