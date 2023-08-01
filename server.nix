{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = hostName; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

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
  users.groups.jobMarketplace = {};
  users.users = {
    jobMarketplace = {
      isSystemUser = true;
      group = "jobMarketplace";
    };
    akegalj = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCSovxiYVKNq64nCgbY5Njj1yl/jTKqqYVtP0WxBTXDyoI2i8JNlNTR2cVkIjF9K5xL2vZ3Z6VhSqCyQ9DKrwK0x6XsSTw44CI/K8GrzXrx/ajxk3YxTdKsoE9I944Jw/VZ5CtfP8EpKTNFPYonme0gshH085qAJmIRyaeHBj98KM13l02QiZ+3gl5Qp0QXE7OGHL+kKSVklUUKgX2i5aPgH5pPXP1hsaTlsgXny8DxY1JYva2iOWM1BzE32YPbJlwnOlctfZqN7i7WKiCbMXuP2bt/FZd3iexuPvMaCi95Cz9v9U/tl/PciVTblyskSVg7ANitTgsG0c/sNhA59t26fDhf9Eppp5lGLDWEtF1jBeZZlhLwYmiG4jfKNp3VJQouPlDsZ1QZatI35PwKI22fpRK0pfAMYkh8buaCaANxOgleBg8/Qt9n/b2BsF4OjV7pd91fWLfsVbX5nQsA8gOr29ClOeAbb9sCiTnOLa5RREv292QpMdKCrWWBDKd0b1U= akegalj@nixos"];
      packages = with pkgs; [
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
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
  # services.openssh.settings.PermitRootLogin = "yes";

  # For keter config see https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/web-servers/keter/default.nix#L120
  # and https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/web-servers/keter/default.nix#L120
  # and https://github.com/jappeace/yesod-keter-nix/blob/418b120c47140c0cd196f7eb933ffa192a60dd66/flake.nix
  systemd.services."job-marketplace" = {
    description = "Job marketplace";
    script = let app = import (/home/akegalj/projects/job-marketplace/.); in "${app}/bin/job-marketplace";
    wantedBy = ["multi-user.target" "ngingx.service" ];
    serviceConfig = {
      User = "jobMarketplace";
      Group = "jobMarketplace";
      # AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      Restart = "always";
      RestartSec = "10s";
    };
    after = [
      "network.target"
      "local-fs.target"
      "postgresql.service"
    ];
  };
    
  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = ["nix-command" "flakes"];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3000 ];
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

