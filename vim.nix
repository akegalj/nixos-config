{ config, pkgs, ... }:
let vim = if config.services.xserver.enable then pkgs.vim-full else pkgs.vim;
    myvim = vim.customize {
      vimrcConfig.packages.myplugins.start = with pkgs.vimPlugins; [ 
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
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    };
in
{
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages = [ myvim ];
  users.users.akegalj.packages = [ pkgs.ormolu ];
}
