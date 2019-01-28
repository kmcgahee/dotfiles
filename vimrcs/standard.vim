


" Set Options
" --------------

set encoding=utf-8
set hlsearch			" Highlight search results
set incsearch			" Turn on incremental searching
set lazyredraw                 " don't update the display while executing macros
syntax on                      " enable syntax highlighting
filetype on                   " highlight syntax based on file extension
set autowrite "Auto save file when switching buffers
set wildmenu  " Better tab complete when opening files
set nocompatible " Never disable vim features to be compatible with vi
set nu " Turn on line numbering
set spell spelllang=en_us " use z= to see spelling suggestions


" F-key Shortcuts
" --------------

" Show buffers and then type in number or part of file and hit enter
nnoremap <F5> :ls<CR>:b<Space>

" Use 'tagbar' plugin to show entire file structure
nmap <F8> :TagbarToggle<CR>


" Core mapping
" --------------

let mapleader = ","  " Default is backslash \

imap jk <Esc>

" Yank to the end of the line instead of the whole line
nnoremap Y y$


" Formatting
" --------------

" Default settings for all file types (overridden below)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=0
set wrapmargin=0
set nowrap
set expandtab
set autoindent
set fileformat=unix

au BufNewFile,BufRead *.html,*.css,*.scss,*.js,*.jsx,*.ts,*.tsx
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Open all folds by default
au BufRead,BufWinEnter * normal zR

" Show misspelled words in bold
hi clear SpellBad
hi SpellBad cterm=bold
hi clear SpellRare
hi clear SpellCap
hi SpellCap cterm=bold
hi clear SpellLocal
hi SpellLocal cterm=bold


" Navigation
" --------------

" Set default locations when creating new split
set splitbelow
set splitright

" Avoid Ctrl-W when navigating or creating new splits.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" Convenience
" --------------

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" This keeps the current visual block selection active after changing indent with '<' or '>'.
" Usually the visual block selection is lost after you shift it, which is really annoying.
vmap > >gv
vmap < <gv


" Plugins (vim-plug)
" --------------

call plug#begin('~/.vim/plugged')


" ================
" Formatting / Highlighting
" ================

" Better syntax highlighting and formatting, also highlights JSDocs
" Note: this supports Flow but not TypeScript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Correct 'folding' and better indentation rules for python
Plug 'tmhedberg/simpylfold'
Plug 'vim-scripts/indentpython.vim'

" Show trailing whitespace and offer :StripWhitespace to remove all.
Plug 'ntpeters/vim-better-whitespace'

" Solarized color scheme for vim.
" Note: requires using Solarized for terminal color scheme and also manually copying files.
Plug 'altercation/vim-colors-solarized'


" ================
" Information
" ================

" Open side-bar showing tag structure in file
Plug 'majutsushi/tagbar'

" Status bar at bottom of file
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


" ================
" Other
" ================

" Async linter
Plug 'w0rp/ale'

" Easy writing
" Plug 'junegunn/goyo.vim'


" ================
" Navigation
" ================

" File system explorer.
Plug 'scrooloose/nerdtree'

" Use 2-character sequence to jump to anywhere in the file.
Plug 'easymotion/vim-easymotion'

" Map ctrl+<hjkl> to move between panes without conflicting with tmux.
Plug 'christoomey/vim-tmux-navigator'

" Fuzzy file finder (e.g. :Files, :Commits) works with more than vim
" Note: need to install using git clone and install.sh
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" More robust version of ctags, use C^-] and C^-t to nav
Plug 'universal-ctags/ctags'


" Automatically update tags on save
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-easytags'


" Another good fuzzy finder seems to be CTRLP
" https://vimawesome.com/plugin/ctrlp-vim-everything-has-changed

" ================
" Convenience
" ================

" Three things in one,
"  1) common corrections for misspelled words
"  2) capital S for smart case replacements
"  3) shortcuts for reformatting casing (crm = coerce to snake case)
Plug 'tpope/vim-abolish'

" 20 convenient mappings starting with ] and [
Plug 'tpope/vim-unimpaired'

" Git wrapper (:Gblame, etc)
Plug 'tpope/vim-fugitive'

" Easily insert 'templates' (snippets)
" The 1st is the engine, the 2nd plugin is the actual snippets collection.
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Automatically close () " etc
"Plug 'townk/vim-autoclose'

" Also need to install https://valloric.github.io/YouCompleteMe/#ubuntu-linux-x64
" You-complete me is slow on vim compiled with python2, can add this back in
" in the future
"Plug 'valloric/youcompleteme'
"let g:ycm_collect_identifiers_from_tags_files = 1
"let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_min_num_of_chars_for_completion = 3


" All Plugins must be added before the following line
call plug#end()


" Plugin Config
" --------------

" <<< indentpython.vim >>>
" -------------------------

let python_highlight_all=1


" <<< vim-colors-solarized >>>
" -------------------------

let g:solarized_termcolors=256
set background=dark
"let g:solarized_termtrans = 1
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
"colorscheme solarized


" <<< vim-jsx >>>
" -------------------------

" Allow JSX in .js files
let g:jsx_ext_required = 0


" <<< ultisnips >>>
" -------------------------

" Set trigger for pulling up snippet selection.
" NOTE: Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" <<< ctags >>>
" -------------------------

set tags=./tags,./TAGS,tags;~,TAGS;~


" <<< vim-easymotion >>>
" -------------------------

 " Disable default mappings
let g:EasyMotion_do_mapping = 0

" Need one more keystroke, but on average, it may be more comfortable.
"map <Space> <Plug>(easymotion-overwin-f2)
map <Leader><Leader> <Plug>(easymotion-bd-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1


" <<< ale >>>
" -------------------------

" Set this. Airline will handle the rest for ALE
let g:airline#extensions#ale#enabled = 1

"nmap <silent> <Leader>k <Plug>(ale_previous_wrap)
"nmap <silent> <Leader>j <Plug>(ale_next_wrap)

let b:ale_fixers = { 'javascript': ['eslint'], 'python': ['black'] }
let b:ale_linters = { 'python': ['flake8'] }

