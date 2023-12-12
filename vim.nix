{ config, pkgs, ... }:
let
    badwolf = pkgs.vimUtils.buildVimPlugin {
      name = "badwolf";
      src = pkgs.fetchFromGitHub {
        owner = "sjl";
        repo = "badwolf";
        rev = "682b521";
        sha256 = "Dl4zaGkeglURy7JQtThpaY/UrNIoxtkndjF/HJw7yAg=";
      };
    };
    vim-syntax-shakespeare = pkgs.vimUtils.buildVimPlugin {
      name = "vim-syntax-shakespeare";
      src = pkgs.fetchFromGitHub {
        owner = "pbrisbin";
        repo = "vim-syntax-shakespeare";
        rev = "2f4f61e";
        sha256 = "sdCXJOvB+vJE0ir+qsT/u1cHNxrksMnqeQi4D/Vg6UA=";
      };
    };
    vim = if config.services.xserver.enable then pkgs.vim-full else pkgs.vim;
    myvim = vim.customize {
      vimrcConfig.packages.myplugins.start = with pkgs.vimPlugins; [
          vim-nix
          vim-lastplace
          # vim-ormolu
          vim-syntax-shakespeare
          vimwiki
          editorconfig-vim
          vim-textobj-user
          zenburn
          badwolf
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
