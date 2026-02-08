" ======================
" Load Vim defaults (recommended baseline)
" ======================

unlet! skip_defaults_vim      " Ensure Vim does NOT skip loading defaults
source $VIMRUNTIME/defaults.vim
                              " Load Vim's sensible default settings

" ======================
" Core Vim features
" ======================

filetype plugin indent on     " Enable filetype detection, plugins, and indent rules
syntax on                     " Enable syntax highlighting

runtime macros/matchit.vim    " Enhance % jumps (if/else, do/done, etc.)

" ======================
" UI / Ergonomics
" ======================

set number                    " Show absolute line numbers
" set relativenumber            " Show relative line numbers for easier navigation
set ruler                     " Show cursor position (line and column)
set showmatch                 " Highlight matching brackets/braces
set cursorline                " Highlight the current cursor line
set signcolumn=yes            " Always show sign column to avoid text shifting
set laststatus=2              " Always show the status line
set showmode                  " Display current mode (INSERT, VISUAL, etc.)

set wrap                      " Enable visual line wrapping
set linebreak                 " Wrap at word boundaries instead of mid-word
set showbreak=+++             " Prefix wrapped lines with +++
set textwidth=0               " Disable automatic hard line wrapping for code
set colorcolumn=100           " Visual guide at 100 characters

" ======================
" Search behavior
" ======================

set hlsearch                  " Highlight all search matches
set incsearch                 " Show search results as you type
set ignorecase                " Case-insensitive search by default
set smartcase                 " Case-sensitive if search contains uppercase

" ======================
" Indentation defaults
" ======================

set expandtab                 " Convert tabs to spaces by default
set autoindent                " Copy indentation from current line
set smartindent               " Smarter indentation for programming languages
set shiftwidth=4              " Number of spaces for each indent level
set softtabstop=4             " Number of spaces a <Tab> feels like
set tabstop=4                 " Width of a literal tab character
set smarttab                  " Tab respects shiftwidth at line start

" ======================
" Undo / buffer / file handling
" ======================

set backspace=indent,eol,start " Allow backspacing over indent, EOL, and start
set undolevels=1000           " Store a deep undo history
set undofile                  " Persist undo history across sessions
set hidden                    " Allow switching buffers without saving
set updatetime=250            " Faster CursorHold events and swap writes

" ======================
" Whitespace visibility
" ======================

set list                      " Make whitespace characters visible
set listchars=tab:»·,trail:·,extends:»,precedes:«,nbsp:␣
                              " Define symbols for whitespace characters

" ======================
" Split window behavior
" ======================

set splitright                " Vertical splits open to the right
set splitbelow                " Horizontal splits open below

" ======================
" Spell checking
" ======================

set nospell                   " Disable spell checking by default

" ======================
" Filetype-specific rules
" ======================

augroup ft_coding             " Group for language-specific settings
  " Clear existing autocmds in this group (autocmd! can't have trailing comments)
  autocmd!

  " Go: use real tabs (gofmt standard)
  autocmd FileType go
        \ setlocal noexpandtab
        \ tabstop=4
        \ shiftwidth=4
        \ softtabstop=4

  " JavaScript / TypeScript: 2-space indentation
  autocmd FileType javascript,typescript,typescriptreact,javascriptreact
        \ setlocal expandtab
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2

  " Bash / shell scripts: 2-space indentation
  autocmd FileType sh,bash,zsh
        \ setlocal expandtab
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2

  " Markdown & git commits: wrapping and spell checking
  autocmd FileType markdown,gitcommit
        \ setlocal spell
        \ wrap
        \ linebreak
augroup END

" ======================
" Convenience mappings
" ======================

nnoremap <silent> <Esc> :nohlsearch<CR><Esc>
                              " Clear search highlighting with Esc

set pastetoggle=<F2>           " Toggle paste mode to prevent auto-indent issues

" ======================
" Trailing whitespace cleanup
" ======================

augroup trim_ws                " Group for whitespace trimming
  " Clear existing autocmds in this group (autocmd! can't have trailing comments)
  autocmd!

  autocmd BufWritePre
        \ *.go,*.js,*.ts,*.tsx,*.jsx,*.sh,*.bash,*.zsh,*.json,*.yaml,*.yml
        \ %s/\s\+$//e
                              " Remove trailing whitespace on save
augroup END

" ======================
" Fast searching with ripgrep
" ======================

if executable('rg')            " Only enable if ripgrep is installed
  set grepprg=rg\ --vimgrep\ --smart-case
                              " Use ripgrep for :grep searches
  set grepformat=%f:%l:%c:%m
                              " Format ripgrep output for quickfix
endif

