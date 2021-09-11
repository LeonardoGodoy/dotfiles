" Vimrc

" Need to set the leader before defining any leader mappings
let mapleader = "\<Space>"

set number
set numberwidth=5

set backspace=2      " backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler            " show the cursor position all the time
set showcmd          " display incomplete commands
set incsearch        " do incremental searching
set laststatus=2     " always display the status line
set autowrite        " automatically :write before running commands
set formatoptions-=t " don't auto-break long lines (re-enable this for prose)

set textwidth=100
set colorcolumn=+1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Open new split panes to right and bottom
set splitbelow
set splitright

" Move between wrapped lines, rather than jumping over wrapped segments
nmap j gj
nmap k gk

" Use C-Space to Esc out of any mode
nnoremap <C-Space> <Esc>:noh<CR>
vnoremap <C-Space> <Esc>gV
onoremap <C-Space> <Esc>
cnoremap <C-Space> <C-c>
inoremap <C-Space> <Esc>

nnoremap <leader>sop :source %<cr>

" Search and replace
set hlsearch
set incsearch
set ignorecase
set smartcase

colorscheme jellybeans

" vim:ft=vim
