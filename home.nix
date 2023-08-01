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
  i18n.extraLocaleSettings.LC_TIME = "hr_HR.UTF-8";

  fonts = {
    enableDefaultFonts = true;
    fonts = [ pkgs.ubuntu_font_family ];
  };

  services.xserver = {
    enable = true;
    layout = "hr";
    xkbVariant = "";
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

  sound.enable = true;

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
      texlive.combined.scheme-full
      wget
      acpi
      lm_sensors
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      vanilla-dmz
      irssi
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    loginShellInit = "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && XINITRC=${./xinitrc} XRESOURCES=${./Xresources} exec startx";
    variables = { HISTSIZE = "10000"; BROWSER = "qutebrowser"; };
    shellAliases.ssh = "TERM=xterm ssh";
    interactiveShellInit = "set -o vi";
    systemPackages = [];
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

  system.stateVersion = "23.05";
}
