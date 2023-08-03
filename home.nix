{ config, pkgs, ... }:

{
  imports =
    [
      ./vim.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zagreb";
  console.keyMap = "croat";
  fonts.fonts = [ pkgs.ubuntu_font_family ];
  sound.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    enable = true;
    layout = "hr";
    displayManager.startx.enable = true;
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile ./xmonad.hs;
        extraPackages = haskellPackages: [
          haskellPackages.data-default
        ];
      };
    };
  };

  users.users.akegalj = {
    isNormalUser = true;
    description = "akegalj";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      firefox
      qutebrowser
      vimb
      zulip
      rxvt-unicode
      zathura
      feh
      texlive.combined.scheme-full
      wget
      acpi
      lm_sensors
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      vanilla-dmz
      irssi
    ];
  };

  environment = {
    loginShellInit = "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && XINITRC=${./xinitrc} XRESOURCES=${./Xresources} exec startx";
    variables = { HISTSIZE = "10000"; BROWSER = "qutebrowser"; };
    shellAliases.ssh = "TERM=xterm ssh";
    interactiveShellInit = "set -o vi";
    systemPackages = [];
  };

  programs = {
    gnupg.agent.enable = true;
    # https://opensource.com/article/19/4/gpg-subkeys-ssh
    # gnupg.agent.enableSSHSupport = true;
    git = {
      enable = true;
      config.user = {
        email = "akegalj@gmail.com";
        name = "Ante Kegalj";
      };
      config.init.defaultBranch = "main";
      config.safe.directory = "~/projects/nixos-config";
    };
    slock.enable = true;
    htop.enable = true;
    light.enable = true;
  };

  nix.binaryCaches = [ "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = [ "nix-command" "flakes" ];
    allow-import-from-derivation = ["true"];
  };

  system.stateVersion = "23.05";
}
