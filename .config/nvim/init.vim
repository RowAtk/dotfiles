call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'

" Nordic theme\
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }
Plug 'rebelot/kanagawa.nvim'
call plug#end()

colorscheme kanagawa

set number relativenumber
