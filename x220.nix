{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "x220"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    # displayManager.gdm.enable = true;
    
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile /home/akegalj/.xmonad/xmonad.hs;
        extraPackages = haskellPackages: [
          haskellPackages.data-default
        ];
      };
    };
    
    displayManager = {
      startx.enable = true;

      # NOTE: this might not be needed
      defaultSession = "none+xmonad";
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "hr";
    xkbVariant = "";
  };

#  services.keter = {
#    enable = true;
#    bundle.appName = "job-marketplace";
#    bundle.executable = import (/home/akegalj/projects/job-marketplace/.);
#  };
#  systemd.services."job-marketplace" = {
#    description = "Job marketplace";
#    script = let app = import (/home/akegalj/projects/job-marketplace/.); in "${app}/bin/job-marketplace";
#    wantedBy = ["multi-user.target" "ngingx.service" ];
#    serviceConfig = {
#      Restart = "always";
#      RestartSec = "10s";
#    };
#    after = [
#      "network.target"
#      "local-fs.target"
#      "postgresql.service"
#    ];
#  };

  # Configure console keymap
  console.keyMap = "croat";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;

  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
      slock
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    loginShellInit = "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx";
    variables = { EDITOR = "vim"; TERM = "xterm"; HISTSIZE = "10000"; BROWSER = "qutebrowser"; };
    interactiveShellInit = ''
      set -o vi
    '';
    systemPackages = with pkgs; [
      # NOTE: use vim (not vim-full) if intented use is terminal only
      (vim-full.customize {
          # Install plugins for example for syntax highlighting of nix files
          vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
            start = [ 
              vim-nix
              vim-lastplace
              vim-ormolu
              vimwiki
              editorconfig-vim
              vim-textobj-user
              zenburn
              vim-colors-solarized
              ctrlp
            ];
            opt = [];
          };
          vimrcConfig.customRC = ''
            " your custom vimrc
            set nocompatible
            " allow backspacing over everything in insert mode
            " set ts=2 sts=2 sw=2 expandtab
            set backspace=indent,eol,start
            " Turn on syntax highlighting by default
            filetype plugin indent on     " required!
            syntax on

            " Tab specific option
            set tabstop=2                   "A tab is 8 spaces
            set expandtab                   "Always uses spaces instead of tabs
            set softtabstop=2               "Insert 2 spaces when tab is pressed
            set shiftwidth=2               "An indent is 2 spaces
            set smarttab                    "Indent instead of tab at start of line
            set shiftround                  "Round spaces to nearest shiftwidth multiple
            set nojoinspaces                "Don't convert spaces to tabs
            set nu
            set ignorecase
            set smartcase
            set autoindent
            nnoremap <C-j> <C-w>j
            nnoremap <C-k> <C-w>k
            nnoremap <C-h> <C-w>h
            nnoremap <C-l> <C-w>l
            nnoremap <C-w> <C-w>w

            "Use the same symbols as TextMate for tabstops and EOLs
            " set listchars=tab:▸\ ,eol:¬
            " set list


            "Invisible character colors
            " highlight NonText guifg=#d2d2d2
            " highlight SpecialKey guifg=#d2d2d2


            " Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

            set mouse=a

            " make line navigation ignore line wrap
            nmap j gj
            nmap k gk

            let g:ctrlp_switch_buffer = 'et'
            let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
            let g:ctrlp_cmd = 'CtrlPMixed'
            set wildignore+=*.pyc,*.pdf,*/env/*,*/js_build/*,*/build/*,*/node_modules/*,*/output/*,*/bower_components/* " ctrlp won't index pyc
            " set directory=$HOME/.vim/swapfiles//
            
            au BufRead /tmp/mutt-* set tw=72

            vnoremap <C-c> "*y
            noremap <S-Insert> "*p

            set nofixeol
            set noeol

            let g:ormolu_options = ["--no-cabal"]
          '';
        }
      )
      wget
      git
      htop
      acpi
      lm_sensors
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      vanilla-dmz
      texlive.combined.scheme-full
      irssi
      ormolu
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  #   enableSSHSupport = true;
  };

  nix.settings = {
    trusted-users = ["root" "akegalj"];
    experimental-features = [ "nix-command" "flakes" ];
    allow-import-from-derivation = ["true"];
    binary-caches = [ "https://cache.nixos.org" "https://nixcache.reflex-frp.org" ];
    binary-cache-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
