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
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDV8BUloLrD8uL+H5MXddmwS1ncgPyfL9425KVmMTuoVuR37quFPOKCANs2df930t4Bmizn1S+Ap02hOfqwZBFMnMk2ozxC1FvWCYO6Judi0SPHsaFxmbOc2++U0TjwVDHhHwMUVTBlGHpv1zYws9dNYlml8XG275K03I6UFf3I6LKh4hTA9X7gd5nI4ovJ4GG3yPWrZER7Lh9+lf1mM9V0mugraObQJ7ajytT8VESqSSWlgmOrQg/hE7kmEc+LfEh0gQ9j2ufN0q5WN4z+my58Uz9fY/PHwIrizgYWWo7vXkXJp09hcYQi1aMt0PvHwYFtGDWFGP/Sw5MNFR6Z25CLwAG7fK/hjiGWKrWPxbNe2OiUuJTCpjEZGtM0AL/XWPaaGql8GXKsqLE3VJKfq1LH20BOG/SWGN+dDuMd8kU/C+xcJuvBfjt0AwdUg7xBoT1nzEnUc0007aUxB6dCgyV5qqSHuLR5VHhhhCX9+SMXogh4BOphAyJpCKhRravRf8OSev+32CevNJTu+HJ3DdAcFXo0VfdMsWLpfb4eYYFaOsk6oc/DvddZojXmfOOEQqhTd39Kv35GFk1LscWb0Fdqml/z0EQgzF6J5txJPXSAh4UoKmzjUBGo5swyBCR3EUh58fxxKcaCES1Mm/CZtbKDJsWQxPrd8zVykvNsU/z+ZQ== openpgp:0xDE4F7B85"];
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
