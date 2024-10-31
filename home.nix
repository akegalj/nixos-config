{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
      ./vim.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = ["dev-agents.livtours.com"];
  };

  time.timeZone = "Europe/Zagreb";
  console.keyMap = "croat";
  fonts.fonts = [ pkgs.ubuntu_font_family ];
  sound.enable = true;
  nixpkgs.config.allowUnfree = true;

#  services.postgresql.enable = true;
#  services.postgresql.package = pkgs.postgresql_15;
#  services.postgresql.initialScript = pkgs.writeText "psql-init" ''
#    CREATE USER akegalj WITH SUPERUSER PASSWORD 'website';
#    CREATE DATABASE website WITH OWNER akegalj;
#  '';
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
  hardware.pulseaudio.enable = true;

  users.users.akegalj = {
    isNormalUser = true;
    description = "akegalj";
    # NOTE: dialout is for arduino-ide
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "audio" ];
    packages = with pkgs; [
      unstable.devenv
      firefox
      qutebrowser
      # vimb
      # zulip
      rxvt-unicode
      zathura
      feh
      texlive.combined.scheme-full
      xclip
      wget
      acpi
      lm_sensors
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      vanilla-dmz
      irssi
      urlscan
      msmtp
      w3m
      neomutt
      mpv
      scrot
      unstable.graphite-cli
#      (ffmpeg.override {
#        withXcb = true;
#      })
    ];
  };

  environment = {
    etc."msmtprc".source = ./msmtprc;
    loginShellInit = let home = "/home/akegalj"; in ''
      [[ ! -f ${home}/.haskeline ]] && echo "editMode: Vi" > ${home}/.haskeline
      [[ ! -f ${home}/.inputrc ]] && echo "set editing-mode vi" > ${home}/.inputrc
      [[ ! -f ${home}/.aliases ]] && touch ${home}/.aliases
      [[ -f ${home}/.cache/mutt ]] && rm ${home}/.cache/mutt # TODO: remove later, this is temporary to fix cache
      [[ ! -d ${home}/.cache/mutt ]] && mkdir -p ${home}/.cache/mutt
      PASSWORD_STORE_DIR=${home}/.password-store
      [[ ! -f ${home}/.gnupg/sshcontrol ]] && echo "9D9341EBB28348D3718E0F1BC60C0924F77A10D2" > ${home}/.gnupg/sshcontrol
      [[ ! -d $PASSWORD_STORE_DIR ]] && pass init akegalj && pass git init && pass git remote add origin git@github.com:akegalj/pass.git && pass git config pull.rebase true && pass git pull -r --set-upstream origin main
      [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && XINITRC=${./xinitrc} XRESOURCES=${./Xresources} exec startx
    '';
    variables = {
      HISTSIZE = "10000";
      HISTCONTROL = "ignoredups:ignorespace";
      BROWSER = "qutebrowser";
    };
    shellAliases.ssh = "TERM=xterm ssh";
    # shellAliases.zulip = "GDK_BACKEND=x11 zulip";
    shellAliases.ghci = "ghci -v0 -ignore-dot-ghci -ghci-script ${./ghci}";
    # use `qpdf --decrypt bla.pdf uncompressed.pdf` as an alternative
    shellAliases.uncomp = "pdftk '$(echo $FILE)' output uncompressed.pdf uncompress";
    # use ghostscript to fix any broken pdf `gs -o repaired.pdf -sDEVICE=pdfwrite -dPDFSETTINGS/prepress uncompressed.pdf`
    shellAliases.comp = "FILE_E=`echo $FILE | sed 's/\.pdf//'` pdftk uncompressed.pdf output '$(echo $FILE_E)_fixed.pdf' compress";
    shellAliases.scrot = "PRINT_SCREEN=~/pictures/$(date '+%Y%m%d-%H%M%S').png; scrot -s $PRINT_SCREEN && cat $PRINT_SCREEN | xclip -selection clipboard -t image/png";
    shellAliases.xsel = "xclip -selection primary";
    interactiveShellInit = "set -o vi";
    systemPackages = [];
  };


  programs = {
    gnupg.agent.enable = true;
    # gnupg.agent.enableSSHSupport = true;
    # NOTE: Use ssh-add to add a key to the agent
    ssh.startAgent = true;
    git = {
      enable = true;
      config.user = {
        email = "akegalj@gmail.com";
        name = "Ante Kegalj";
      };
      config.init.defaultBranch = "main";
      config.safe.directory = "${./.}";
      config.core.excludesFile = "${./gitignore}";
      config.url."https://".insteadOf = "git://";
    };
    slock.enable = true;
    htop.enable = true;
    light.enable = true;
    # used for livtours frontend dev
    # for alternative see https://nix.dev/guides/faq#how-to-run-non-nix-executables
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        gmp
      ];
    };
    direnv.enable = true;
  };

  # set default browser to qutebrowser
  xdg.mime.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };
  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";

  nix.binaryCaches = [ "https://nixcache.reflex-frp.org" "https://miso-haskell.cachix.org" "https://cache.iog.io"];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "miso-haskell.cachix.org-1:6N2DooyFlZOHUfJtAx1Q09H0P5XXYzoxxQYiwn6W1e8=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = [ "nix-command" "flakes" ];
    allow-import-from-derivation = ["true"];
  };

  hardware.ledger.enable = true;

  system.stateVersion = "23.05";
}
