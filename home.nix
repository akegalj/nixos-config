{ config, pkgs, ... }:

{
  imports =
    [
      ./vim.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      ubuntu_font_family
    ];
  };

  services.xserver = {
    enable = true;
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

  services.xserver = {
    layout = "hr";
    xkbVariant = "";
  };

  console.keyMap = "croat";

  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.akegalj = {
    isNormalUser = true;
    description = "akegalj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      qutebrowser
      vimb
      zulip
      rxvt-unicode
      zathura
      feh
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # $ nix search wget
  environment = {
    loginShellInit = "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && XINITRC=${./xinitrc} XRESOURCES=${./Xresources} exec startx";
    variables = { HISTSIZE = "10000"; BROWSER = "qutebrowser"; };
    shellAliases = { ssh = "TERM=xterm ssh"; };
    interactiveShellInit = ''
      set -o vi
    '';
    systemPackages = with pkgs; [
      wget
      acpi
      lm_sensors
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      vanilla-dmz
      texlive.combined.scheme-full
      irssi
      ormolu
    ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
    # enableSSHSupport = true;
    };
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
    slock.enable = true;
    htop.enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = [ "nix-command" "flakes" ];
    allow-import-from-derivation = ["true"];
  };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.05";
}
