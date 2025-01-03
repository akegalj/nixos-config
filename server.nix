{ config, pkgs, ... }:

{
  imports =
    [
      ./vim.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  # boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Zagreb";

  users.users.akegalj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCLb3FOaO6TGSKkXsKimMtdi62Z6nz8Vd4KXA3rNbU6a05v0e1JqS8O8DA0E0zX6FjTmALrCez2iRaLx3724jFIoe18EJNqVHSX/opkh4w7AbDyuSOfZ5lpRc1s+8/e30lqMSa7hcXJXYblEKSA7nuuwjRfs+dDH/4mDPHND5IXeuOtNJK5AesiArCqhWiX7oMDGA0RaZa54XI0Oe7WDTHnWM4eQs+hZJCi2ZtvrlhS1XvXEBWwk2RpOHkKqxGY9qp9jmXe3EYlPmpU5HMKSt/Q5TFqdxWgVncvH+ERj34P5gdW3GWHBC+HGxH/t2zNnuyLNFyPaQ2lhRQvCcyf2tHAvsai3xfQc/+4wG9VfKbOibzGF9+xAWBNrKMp+IVnFmDFQ2bkxtsAJy8vbDY5lIH+PgKH7rHxuVcm0t4NaOnO1ezIAO1DvvEhAcgHu8fH89PAtp8kWIjbSYBoHZERz8e/y91FhMdajfFLDbVPS1LkxCDLyavCiX02h2Q3k8Letc8= akegalj@x220" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDM+aY/sdenyjzsyXy/WGcm44Ef2A1Khk4IZsdSuJQNtiyLrnw6KXKroDQn7BOhxq61B/C0ZiGITqx5TtI94sDnQCCAWNvWH7uDUY4OnOAi1kJ1MmP1AfFtiIEBnwK7QvFFNPhdbtfRWml/S0u9g+FKbwfQmmk15+riKkZiWEsKf7B5T4UZN9axcPEBBUNAp4frzUGnNNVN0BpAa2CJ5y7uIdzncNpBA7oofLYwrfDgr2+cQKggfsk4wQ7xqDWb47xv8JgS6ky2S2Yq6i8+b+cluHBo8j+9oUvOkCYGvV47iBGlGEf9Qqmb/Agzt3s37mRkytV/1aDw2JIpJf2cnQkZV1VycBRpRkoAmFVpMjZVhCB6epIGYikTTFX9EjVGJmrdkGvltE6CDjmB69xq76Gsq5aABxIF3z+b5UpBz6v3f9SvaX0rw6i3yu2XutqlR821dJoFK2Fpo9Lj65fQ1UJMaBwE0N8wY0OSmyK0o0Z03pLexRqKomWyq8cKl7j3xaU= akegalj@x200" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVKYjnuaMt8I0Mwb5j5VGIAUwW71HM3/TQMCNPJX1J7F2pwyaka/HYGP2P4Dw+nPm3+xBGPzXyqhJ+yrCXlBhQsAsGhT/ukT+lenDT2WjCEGZ3uo08vKwL7wXS5J7mr6buRrQusnzvTCmwZJ+CsyWMtgPHOaxgsMekKI7991nAjJoPPLGUMf7dGFBYG9ZtEbn4KJLpMlBsxjvlftvBdFcvtG9vybYSIZvyEije6Kd5fURWHCIS8JzJnUvc5DPkl3RSGkfgAchIIEkGd39MPqddRw/q0rMsHsYvF1AxB/pwrpvc6Ch+Zfi7GMLRYSV/4CKhu76JL7Xb0RRf2zUOiSYcWUNc2GPzELITbDuh8jO5NLVTGwH8+0ebzz9dar7zNEC9VO5/wsqKbn0SO1N2qnAIb0AWDyXuIM3OPT6qwhiwWNPUVRZY7/ImohLI+UL0JgmPRs8wGHu5ZkdhQyszknCAHtoqBDY2EoznkTTF6mFGd+aESjznCjsyaxg75yjKmRE= akegalj@system76"];
    packages = [ ];
  };

  environment = {
    variables.HISTSIZE = "10000";
    shellAliases.ssh = "TERM=xterm ssh";
    interactiveShellInit = "set -o vi";
    systemPackages = [];
  };

  services.pipewire.enable = false;
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

  system.stateVersion = "23.11";
}
