" Kyle McGahee

" NOTES {{{
"
" This .vimrc is inspired by various others:
" - https://github.com/dougblack/dotfiles/blob/master/.vimrc
" - https://github.com/amix/vimrc/tree/master/vimrcs
" - https://raw.githubusercontent.com/nvie/vimrc/master/vimrc
" - https://github.com/aykamko/dotfiles/blob/master/vim/vimrc
"
" Things to do:
"  - Ensure mappings are using correct mapping type (i.e. what mode)
"  - Make sure all leader key mappings are grouped under 'leader powerups'
"  - Try to categorize groups
" }}}

" GENERAL {{{

" Never disable vim features to be compatible with vi
set nocompatible

" Set the character encoding used inside Vim (default is latin1)
set encoding=utf-8

" Auto save file when switching buffers
set autowrite

" Auto re-read file when it's changed externally
set autoread

" Turn off annoying sound on errors
set noerrorbells
set novisualbell

" Set the <leader> key, the default is backslash \
let mapleader=","

" Define much easier way to get back to Normal mode
imap jk <Esc>
imap Jk <Esc>
imap jK <Esc>
imap JK <Esc>

" Save file after forgetting to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" }}}

" SYNTAX HIGHLIGHTING & FORMATTING {{{

" Enable syntax processing
syntax enable

" Auto-highlight matching parentheses and show it blinking
set showmatch
set mat=2

" Add some extra keywords to Todo highlight group
augroup extra_todo_highlights
  autocmd!
  autocmd Syntax * syn match highlightKeywords
        \ /\v ?<(BEGIN|END|HACK|XXX|INFO|BUG|NOTE|TODO|NOPUSH)(\([^)]*\))?/
        \ containedin=.*Comment.*
augroup END
highlight! def link highlightKeywords Todo

" }}}

" INDENTATION {{{

" Enable specific settings based on file types.
" This needs to be defined early on as it can affect future settings.
filetype plugin on
filetype indent on

" Default settings for all file types (overridden below)
set tabstop=4          " number of visual spaces per TAB
set softtabstop=4      " number of spaces in tab when editing
set shiftround         " When shifting lines, round the indentation to the nearest multiple of “shiftwidth”
set shiftwidth=4       " How many spaces per shift
set textwidth=0        " Disable maximum line length
set nowrap
set wrapmargin=0       " when to wrap text using EOL
set expandtab          " tabs are spaces
set smarttab           " insert tabs on the start of a line according to shiftwidth, not tabstop
set autoindent
set fileformat=unix    " Just use newline, no CR

au BufNewFile,BufRead *.html,*.css,*.scss,*.js,*.jsx,*.ts,*.tsx
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Always use POSIX syntax
let g:is_posix=1

" }}}

" HISTORY & PERSISTENCE {{{

" Increase how many commands and changes to remember
set history=500
set undolevels=500

" Save a persistent 'undo' file.
" NOTE: this directory needs to be created manually.
set undodir=~/.vim/undodir
set undofile

" }}}

" EDITING CHANGES {{{

" Yank to the end of the line instead of the whole line
nnoremap Y y$

" Auto drop into insert mode when deleting text
nnoremap <Backspace> i<Backspace>
nnoremap <Del>   i<Del>

" Configure backspace so it always acts as it should in Insert mode
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Swap ` and ' (for jumping to markers) because ' is much easier to press
nnoremap ' `
nnoremap ` '

" Move vertically by visual line instead of real line (if wrapping is enabled)
nnoremap j gj
nnoremap k gk

" }}}

" LEADER POWERUPS {{{

" Easy way to un-highlight all search results
nnoremap <leader><space> :nohlsearch<CR>

" Toggle between absolute and relative line numbers
nnoremap <leader>l :call <SID>ToggleNumber()<CR>

" Split horizontal/vertically and start with file search open.
nnoremap <leader>hs :new<CR>:GFiles<CR>
nnoremap <leader>vs :vs<CR>:GFiles<CR>

" Toggle viewing the Undo tree
nnoremap <leader>u :UndotreeToggle<CR>

" Switch files using fuzzy search
nnoremap <leader>s :GFiles<CR>

" Only show changes to file, zr will show 3 lines above/below hunks.
nnoremap <leader>hf :GitGutterFold<CR>zr

" Save the current session and resume it with vim -S
nnoremap <leader>m :mksession<CR>

" Use the Ack plugin to search project files (the Ag plugin is depreciated)
" Using ! makes it not wait for all results before showing any
nnoremap <leader>a :Ack!<space>

" Quickly open file explorer. If use 'Find' then will open at current file.
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>m :NERDTreeToggle<CR>

" Use ,d (or ,dd or 20,dd) to delete a line without adding it to the yanked buffer
" This also works in in visual mode
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" Pull word under cursor into LHS of a substitute (for search and replace)
" This uses '#' as a delimiter instead of /
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Comment lines of code
nmap <leader>c :TComment<CR>
vmap <leader>c :TComment<CR>

" Leader keys mapped from plugins
" TODO:

" }}}

" VISUAL MODE {{{

" Keep the current visual block selected after shifting with '<' or '>'.
vmap > >gv
vmap < <gv

" Highlight the last inserted text
nnoremap gV `[v`]

" }}}

" USER INTERFACE {{{

" Turn on relative line numbering
" Also enabling 'number' will make current line the actual number
set relativenumber
set number

" Keep a certain amount of lines in view while scrolling
set scrolloff=7
set sidescrolloff=7

" Don't update the display while executing macros or scripts
set lazyredraw

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Enable tab complete when opening files and ignore generated files
set wildmenu
set wildignore=*.o,*~,*.pyc,*.swp,*.class,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Speed up the updatetime so gitgutter and similar plugins update more often
set updatetime=1500

" Hack to always display sign column
augroup always_display_sign_col
  autocmd!
  autocmd BufEnter * sign define dummy
  autocmd BufEnter * if &buftype !=# 'terminal' |
        \ exec 'sign place 9999 line=1 name=dummy buffer='.bufnr('') |
        \ endif
augroup END

" Use fast terminal settings if scrolling is noticeably slow
"set ttyfast

" Show the current position in the file
" set ruler

" Enable mouse in all modes ('a')
" set mouse=a

" Sometimes files opened using quickfix window don't detect filetype
" so tie it into the "refresh screen" command.
nnoremap <C-w> :filetype detect<cr>:redraw!<cr>

" }}}

" SEARCHING {{{

" Highlight all search results
set hlsearch

" Show highlighted results as you type
set incsearch

" Use the current visual selection to search using * and #
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" }}}

" BUFFERS & SPLITS {{{

" Hide buffers instead of closing them, this also preserves marks and undo buffers
set hidden

" Set default locations for new splits to appear
set splitbelow
set splitright

" Avoid Ctrl-W when navigating or creating new splits.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Show all buffers and then type in number or part of file and hit enter
nnoremap <F5> :ls<CR>:b<Space>

" }}}

" TAGS {{{

" Use 'tagbar' plugin to show entire file structure
nnoremap <F8> :TagbarToggle<CR>

" }}}

" FOLDING {{{

" Allow folding, can us zi to toggle this off/on
set foldenable

" Choose how folds are created. Note this vimrc file uses 'marker'
set foldmethod=indent

" Limit how many folds are allowed
set foldnestmax=10

" Start out with everything unfolded
set foldlevelstart=99

" Define which commands will trigger an auto-unfold
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Add a fold column along the left side
" set foldcolumn=2

" Re-map spacebar to toggling the current fold because it's so common
vnoremap <Space> za

" Mappings to easily toggle fold levels
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>
nnoremap z5 :set foldlevel=5<cr>

" Set modelines so it will check for special modeline at the end of this file
" to auto-collapse just this file using standard triple { instead of indents
set modelines=1

" }}}

" PLUGINS (vim-plug) {{{

call plug#begin('~/.vim/plugged')

" <COLORS AND FONTS> {{{

" Retro colorscheme
Plug 'morhetz/gruvbox'

" Dim background color when window isn't in focus.
Plug 'blueyed/vim-diminactive'


" }}}

" <INDENTATION> {{{

" Show trailing whitespace and offer :StripWhitespace to remove all.
Plug 'ntpeters/vim-better-whitespace'

" Improve indenting for Python
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }

" Guess indent options based on text in current file, or by related files
" in the same / parent directory.
Plug 'tpope/vim-sleuth'

" Smart indenting for shell script
Plug 'vim-scripts/sh.vim--Cla', { 'for': ['sh', 'zsh', 'bash'] }

" }}}

" <SYNTAX HIGHLIGHTING & FORMATTING> {{{

" Better syntax highlighting and formatting, also highlights JSDocs
" Note: this supports Flow but not TypeScript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'typescript'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'typescript'] }

" Add syntax highlighting for JSX in TypeScript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript' }

" Easily align multiple lines (e.g. space around =)
" Plug 'junegunn/vim-easy-align'

" }}}

" <USER INTERFACE> {{{

" Show only the current window having a 'current' line and allow custom coloring if it.
Plug 'miyakogi/conoline.vim'

" Show indentation using vertical bars
Plug 'yggdroot/indentline'

" Make commenting/uncommenting lines easier
Plug 'tomtom/tcomment_vim'

" Show a legit status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Visualize the undo tree using :UndotreeToggle
Plug 'mbbill/undotree'

" Transform the UI to be better for writing using :Goyo
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

" Map ctrl+<hjkl> to move between panes without conflicting with tmux.
Plug 'christoomey/vim-tmux-navigator'

" Remap '.' to allow plugins to tap into it (Unimpaired uses this)
Plug 'tpope/vim-repeat'

" Define more 'text objects' like [ ( <, etc to operate on, e.g. i) will select inside ()
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'bkad/camelcasemotion'
" Plug 'kana/vim-textobj-entire' throws error

" Support for {{ and [[ for syntax highlighting, matching, text object commands, etc
Plug 'mustache/vim-mustache-handlebars', { 'for': ['jinja', 'html'] }

" Show side-bar when hit ", @, or ^R to see what's in registers.
Plug 'junegunn/vim-peekaboo'

" }}}

" <FOLDING> {{{

" Use a better folding algorithm for Python
Plug 'tmhedberg/simpylfold'

" }}}

" <GENERAL> {{{

" Async linter and fixer
" NOTE: this required a newer version of Vim because of an Ubuntu bug that
" would cause the cursor to not display very quickly.
" PPA: https://launchpad.net/~jonathonf/+archive/ubuntu/vim
Plug 'w0rp/ale'

" File system explorer
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }

" Three things in one:
"  1) correction commonly misspelled words
"  2) allow capital S for smart case replacements
"  3) provide shortcuts for reformatting casing (crm=coerce to snake_case)
Plug 'tpope/vim-abolish'

" 20 convenient mappings starting with ] and [
Plug 'tpope/vim-unimpaired'

" Require timeout between hjkl presses to practice using better movement commands
Plug 'takac/vim-hardtime'

" Make FocusGained and FocusLost work with tmux. This is important for
" Fugative and GitGutter plugins
Plug 'tmux-plugins/vim-tmux-focus-events'

" }}}

" <SEARCHING> {{{

" Use 2-character sequence to jump to anywhere in the file
Plug 'easymotion/vim-easymotion'
" | Plug 'haya14busa/vim-easyoperator-line'
" | Plug 'aykamko/vim-easymotion-segments'


" Fuzzy search git repo and populate results in change list
Plug 'mileszs/ack.vim'

" Another good fuzzy finder seems to be CTRLP
" https://vimawesome.com/plugin/ctrlp-vim-everything-has-changed

" Fuzzy file finder (e.g. :Files, :Commits), works with more than just vim
" Note: need to install using git clone and install.sh
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" }}}

" <TAGS> {{{

" More robust version of ctags, use C^-] and C^-t to nav
Plug 'universal-ctags/ctags'

" Auto-generate tags file in local repo while respecting ignore files
" KLM: switch to tim-popes git hooks instead, this isn't working for some reason.
" Plug 'szw/vim-tags'

" Open side-bar showing tag structure in file
" Plug 'majutsushi/tagbar'

" }}}

" <GIT> {{{
" Git wrapper (:Gblame, etc)
Plug 'tpope/vim-fugitive'

" Show diffs in gutter and allow you to stage or fold hunks
Plug 'airblade/vim-gitgutter'
" }}}

" <EASY INSERT / EDITING> {{{

" Easily insert 'templates' (snippets)
" The 1st is the engine, the 2nd plugin is the actual snippets collection.
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Automatically close () " etc
"Plug 'townk/vim-autoclose'

" Easily surround existing text with quotes / HTML blocks
Plug 'tpope/vim-surround'

" Auto-complete
" Also need to install https://valloric.github.io/YouCompleteMe/#ubuntu-linux-x64
Plug 'valloric/youcompleteme'

" }}}

" All Plugins must be added before the following line
call plug#end()
" }}}

" PLUGIN CONFIGURATION {{{

" <<< youcompleteme >>>
" -------------------------

let g:ycm_collect_identifiers_from_tags_files=1
" Enable language specific identifiers
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_min_num_of_chars_for_completion=3
let g:ycm_autoclose_preview_window_after_completion=1


" <<< diminactive >>>
" -------------------------

" Disable syntax highlighting if not active
" KLM: note doesn't work but instead removes all color
" let g:diminactive_use_syntax=1

" Tie in with Vim's unfocus event to dim on that too.
" Note: required tmux-focus-events plugin to work with tmux.
" KLM: note this doesn't work..
" let g:diminactive_enable_focus=1


" <<< vim-airline >>>
" -------------------------

set laststatus=2
" Theme set by gruvbox
" let g:airline_theme='zenburn'
let g:airline_left_sep=''
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_right_sep=''


" <<< vim-hardtime >>>
" -------------------------

let g:hardtime_timeout=500
let g:hardtime_default_on=1
let g:hardtime_showmsg=1
let g:hardtime_ignore_quickfix=1
let g:hardtime_allow_different_key=1
let g:hardtime_maxcount=3


" <<< indentpython.vim >>>
" -------------------------

let python_highlight_all=1


" <<< camelcasemotion.vim >>>
" -------------------------

call camelcasemotion#CreateMotionMappings('<leader>')


" <<< vim-colors-solarized >>>
" -------------------------

let g:solarized_termcolors=256
set background=dark
"let g:solarized_termtrans=1
"let g:solarized_visibility="high"
"let g:solarized_contrast="high"
"colorscheme solarized


" <<< vim-jsx >>>
" -------------------------

" Allow JSX in .js files
let g:jsx_ext_required=0


" <<< ultisnips >>>
" -------------------------

" Set trigger for pulling up snippet selection.
" NOTE: Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" <<< ctags >>>
" -------------------------

" Look for tag file in current directory, otherwise look for .git/tags
" until hit HOME (that's what semi-colon does)
set tags=tags;~


" <<< vim-easymotion >>>
" -------------------------

 " Disable default mappings
let g:EasyMotion_do_mapping=0

" Need one more keystroke, but on average, it may be more comfortable.
"map <Space> <Plug>(easymotion-overwin-f2)
map <leader><leader> <Plug>(easymotion-bd-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase=1


" <<< ale >>>
" -------------------------

" Set this. Airline will handle the rest for ALE
let g:airline#extensions#ale#enabled=1

"nmap <silent> <leader>k <Plug>(ale_previous_wrap)
"nmap <silent> <leader>j <Plug>(ale_next_wrap)

let b:ale_fixers={ 'javascript': ['eslint'], 'python': ['black'] }
let b:ale_linters={ 'python': ['flake8'] }

let g:ale_completion_enabled=0
let g:ale_lint_delay=200   " millisecs
" let g:ale_lint_on_text_changed='always'  " never/insert/normal/always
let g:ale_lint_on_enter=1
let g:ale_lint_on_filetype_changed=1
let g:ale_lint_on_save=1
" let g:ale_fix_on_save=1
" KLM: don't enable quickfix because use that for Ack
" let g:ale_set_quickfix=1

" <<< ack >>>
" -------------------------

" Use ag instead of ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" <<< nerdtree >>>
" -------------------------

let g:NERDTreeWinPos="right"
let NERDTreeShowHidden=0
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>ns :NERDTreeFind<cr>
map <leader>nf :NERDTreeFocus<cr>

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '__pycache__', '\.DS_Store' ]

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Quit on opening files from the tree
let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Close Vim if NERDTree is the only window left
augroup nerdtree_solo_close
  autocmd!
  autocmd BufEnter *
        \ if (winnr("$")==1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |
        \ q |
        \ endif
augroup END


" <<< conoline >>>
" -------------------------

" Enable on startup
let g:conoline_auto_enable=1


" <<< indentline >>>
" -------------------------

" Uncomment this to let colorscheme choose 'conceal' color (instead of gray)
" let g:indentLine_setColors=0

let g:indentLine_char = '|'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg='ag --vimgrep'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
" map <leader>cc :botright cope<cr>
" map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
" map <leader>n :cn<cr>
" map <leader>p :cp<cr>

" }}}

" CUSTOM FUNCTIONS {{{

command! -bang -nargs=* Find call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg=@"
    execute "normal! vgvy"

    let l:pattern=escape(@", "\\/.*'$^~[]")
    let l:pattern=substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/=l:pattern
    let @"=l:saved_reg
endfunction

function! <SID>ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" }}}

" COLORS AND FONTS {{{

" Enable 8 bit color support
set t_Co=256

" Requires gruvbox plugin
" NOTE: this must be set AFTER the plugin section to work.
let g:gruvbox_italic=1
colorscheme gruvbox

" }}}

" SPELLING {{{

" Enable spellcheck. Use z= to see spelling suggestions
set spell spelllang=en_us

" Show misspelled words in bold
" NOTE: this must must after colorscheme for bold to work correctly.
hi clear SpellBad
hi SpellBad cterm=bold
hi clear SpellRare
hi clear SpellCap
hi SpellCap cterm=bold
hi clear SpellLocal
hi SpellLocal cterm=bold

" }}}

" vim:foldmethod=marker:foldlevel=0
