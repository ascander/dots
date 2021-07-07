" Fundamentals "{{{
" --------------------------------------------------------------------------------

set nocompatible               " Ignored in nvim, but let's be explicit

filetype plugin indent on      " Load plugins according to detected filetype

set autoindent                 " Indent according to the previous line
set expandtab                  " Use spaces instead of tabs
set softtabstop=2              " Tab key indents by 2 spaces
set shiftwidth=2               " >> indents by 2 spaces
set shiftround                 " >> indents to the next multiple of 'shiftwidth'

set backspace=indent,eol,start " Make backspace work as expected in insert mode
set hidden                     " Switch between buffers without having to save first
set laststatus=2               " Always show statusline
set display=lastline           " Show as much as possible of the last line

set showmode                   " Show current mode in the statusline
set showcmd                    " Show already typed keys when more are expected

set incsearch                  " Highlight while searching with / or ?
set nohlsearch                 " No persistent highlighting of matches

set ttyfast                    " Faster redrawing
set lazyredraw                 " Only redraw when necessary

set splitbelow                 " Open new windows below the current one
set splitright                 " Open new windows to the right of the current one

set wrapscan                   " Searches wrap around the end of the file
set report=0                   " Always report changed lines

"}}}

" Mappings "{{{
" --------------------------------------------------------------------------------

" Leader keys
let mapleader = ";"
let maplocalleader = ","

" Easy split navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

"}}}

" Backups "{{{
" --------------------------------------------------------------------------------

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir=$HOME/.vim/files/backup/
set backupext=-vimbackup
set backupskip=
set directory=$HOME/.vim/files/swap//
set updatecount=100
set undofile
set undodir=$HOME/.vim/files/undo/
set viminfo='100,n$HOME/.vim/files/info/viminfo

"}}}

" MacOS "{{{
" --------------------------------------------------------------------------------

" Use the system clipboard when on a Mac
if has("unix")
  let s:uname = system("uname -s")
  if s:uname == "Darwin"
    set clipboard=unnamed
  endif
endif

"}}}

" Display "{{{
" --------------------------------------------------------------------------------

set cursorline                 " Find the cursor line quickly
highlight clear SignColumn     " Make signcolumn the same color as line number column
set number relativenumber      " Display hybrid line numbers

" Display non-printable characters
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Automatically resize splits on window resize
au VimResized * exe "normal! \<c-w>="

"}}}

" Colors "{{{
" --------------------------------------------------------------------------------

syntax enable                  " Enable syntax highlighting
set termguicolors              " Enable 24-bit color
set background=dark            " Use the 'dark' version of themes
colorscheme NeoSolarized       " I always come back to you

" Use low-contrast versions of the Solarized palette
let g:neosolarized_contrast = "low"
let g:neosolarized_visibility = "low"

" No bold, underline, or italics, please
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0

"}}}

" Statusline "{{{
" --------------------------------------------------------------------------------

lua << EOF
  local status, lualine = pcall(require, "lualine")
  if (not status) then return end

  lualine.setup {
    options = {
      icons_enabled = false,
      theme = 'solarized_dark'
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = {
        {
            'diagnostics', sources = {'nvim_lsp'}, symbols = {error = '!!', warn = '!?', info = '??', hint = '..'}
        },
        'encoding',
        'filetype'
      },
      lualine_y = { 'filename' },
      lualine_z = { 'location' }
    },
    extensions = { 'fugitive' }
  }
EOF

"}}}

" Fuzzy finding "{{{
" --------------------------------------------------------------------------------

" Telescope bindings
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

" Globally bind 'q' to quit Telescope
lua << EOF
  local actions = require('telescope.actions')

  require('telescope').setup {
    defaults = {
      prompt_prefix = "❯ ",
      selection_caret = "❯ ",
      set_env = { ['COLORTERM'] = 'truecolor' },
      mappings = {
        n = {
          ["q"] = actions.close
        }
      }
    }
  }
EOF

"}}}

" vim: set foldmethod=marker foldlevel=0:
