{ config, pkgs, ... }:

{
  imports =
    [
      ./vim.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
      packages = [ ];
    };
  };

  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          email = "akegalj@gmail.com";
          name = "Ante Kegalj";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
    htop.enable = true;
  };

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

  networking.firewall.allowedTCPPorts = [ 3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.05";
}
