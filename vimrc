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
set cursorline
set wildmenu
set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

colorscheme badwolf

" make line navigation ignore line wrap
nmap j gj
nmap k gk

let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_cmd = 'CtrlPMixed'
set wildignore+=*.pyc,*.pdf,*/env/*,*/js_build/*,*/build/*,*/node_modules/*,*/output/*,*/bower_components/*,*state-node-preview/*,*state-node-mainnet/* " ctrlp won't index pyc
" set directory=$HOME/.vim/swapfiles//

au BufRead /tmp/mutt-* set tw=72

vnoremap <C-c> "+y
noremap <S-Insert> "*p

" Jump to definition
" Alternatively use :tjump bla<tab>
nmap t <C-]>

set nofixeol
set noeol

" remove trailing whitespaces
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd FileType c,python,haskell,nix autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

let g:hamlet_highlight_trailing_space = 0
