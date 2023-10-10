" ==============================
" Colors and Appearance
" ==============================

" Set the runtime path to include the Solarized colorscheme
set runtimepath+=~/.config/nvim/colors/vim-nightfly-colors

" Enable 256 color support
set t_Co=256

" Set the colorscheme to Solarized
" colorscheme solarized
colorscheme nightfly

" Set the background color scheme
set background=dark  " Or use 'light'

" Enable syntax highlighting
syntax enable

" Show line numbers
set number

" ==============================
" Encoding and UI
" ==============================

" Set file encoding to UTF-8
set encoding=utf-8

" Enable line highlighting for the cursor line
set cursorline

" Show line and column number in the status line
set ruler

" Enable mouse support
set mouse=a

" ==============================
" Editing and Indentation
" ==============================

" Enable smart indentation
set smartindent

" Set tab and indent settings
set tabstop=2
set shiftwidth=2
set expandtab

" Soft tab settings for editing
set softtabstop=2 

" Show matching parentheses and brackets
set showmatch

" Enable clipboard support (requires clipboard support to be compiled in)
set clipboard=unnamedplus

" Enable line wrapping
set wrap

" ==============================
" Searching
" ==============================

" Incremental search and highlighting
set incsearch
set hlsearch

" Case settings for search
set ignorecase
set smartcase

" ==============================
" Misc Settings
" ==============================

" Backspace behavior in insert mode
set backspace=indent,eol,start

" CtrlP and other plugin-specific settings
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_show_hidden=1

" Ignore specified files in CtrlP and other scenarios
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/* 

" Auto-quit if only NERDTree buffer is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Disable swap files
set noswapfile

" JSX settings
let g:jsx_ext_required=0

