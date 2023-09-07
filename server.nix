{ config, pkgs, ... }:

{
  imports =
    [
      ./vim.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zagreb";

  users.users.akegalj = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCLb3FOaO6TGSKkXsKimMtdi62Z6nz8Vd4KXA3rNbU6a05v0e1JqS8O8DA0E0zX6FjTmALrCez2iRaLx3724jFIoe18EJNqVHSX/opkh4w7AbDyuSOfZ5lpRc1s+8/e30lqMSa7hcXJXYblEKSA7nuuwjRfs+dDH/4mDPHND5IXeuOtNJK5AesiArCqhWiX7oMDGA0RaZa54XI0Oe7WDTHnWM4eQs+hZJCi2ZtvrlhS1XvXEBWwk2RpOHkKqxGY9qp9jmXe3EYlPmpU5HMKSt/Q5TFqdxWgVncvH+ERj34P5gdW3GWHBC+HGxH/t2zNnuyLNFyPaQ2lhRQvCcyf2tHAvsai3xfQc/+4wG9VfKbOibzGF9+xAWBNrKMp+IVnFmDFQ2bkxtsAJy8vbDY5lIH+PgKH7rHxuVcm0t4NaOnO1ezIAO1DvvEhAcgHu8fH89PAtp8kWIjbSYBoHZERz8e/y91FhMdajfFLDbVPS1LkxCDLyavCiX02h2Q3k8Letc8= akegalj@x220"];
    packages = [ ];
  };

  environment = {
    variables.HISTSIZE = "10000";
    shellAliases.ssh = "TERM=xterm ssh";
    interactiveShellInit = "set -o vi";
    systemPackages = [];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  programs = {
    git = {
      enable = true;
      config.user = {
        email = "akegalj@gmail.com";
        name = "Ante Kegalj";
      };
      config.init.defaultBranch = "main";
      config.safe.directory = "~/projects/nixos-config";
    };
    htop.enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = ["nix-command" "flakes"];
  };

  # networking.firewall.allowedTCPPorts = [];

  system.stateVersion = "23.05";
}
