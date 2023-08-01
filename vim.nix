{ config, pkgs, ... }:
let vim = if config.services.xserver.enable then pkgs.vim-full else pkgs.vim;
    myvim = vim.customize {
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
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    };
in
{
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages = [ myvim pkgs.ormolu ];
}
