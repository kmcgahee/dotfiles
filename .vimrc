" Kyle McGahee

" NOTES {{{
"
" Search for INIT in this file to see steps that must be manually performed
" when first using this.
"
" PRUNE are notes to myself for things to consider removing in the future.
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
"  - Map out leader keys mapped automatically by plugins (see TODO for this)
"  - Try to categorize groups
"
"  General reminders for myself:
"  on mapping
"   noremap = non-recursive map (i.e. doesn't expand)
"   :map does nvo == normal + (visual + select) + operator pending
"   :map! does ic == insert + command-line mode (as stated on help map-modes tables.)
"   So To map to all modes you need both :map and :map!.
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
" NOTE: this 'tee' hack doesn't work in nvim, use the SudaPlugin instead.
" cmap w!! w !sudo tee > /dev/null %
cmap w!! :SudaWrite<CR>


" }}}

" SYNTAX HIGHLIGHTING & FORMATTING {{{

" Enable syntax processing
syntax enable

" Enable specific settings based on file types.
" This needs to be defined early on as it can affect future settings.
filetype plugin on
filetype indent on

" Auto-highlight matching parentheses and show it blinking
set showmatch
set mat=2

" Look back further in the buffer to figure out syntax highlighting.
" This helps a ton in React w/ styled-components.
" NOTE: this overridden by the commands below, but left this here for other
" file types.
autocmd BufEnter * :syntax sync minlines=1000

" Highlighting for large files
" Copied from: https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" Sometimes syntax highlighting can get out of sync in large JSX and TSX files.
" This was happening too often for me so I opted to enable syntax sync fromstart, which forces vim to rescan the entire buffer when highlighting.
" This does so at a performance cost, especially for large files. It is significantly faster in Neovim than in vim.
" I prefer to enable this when I enter a JavaScript or TypeScript buffer, and disable it when I leave:
autocmd BufEnter *.{js,jsx,ts,tsx,vue} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx,vue} :syntax sync minlines=1000


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
" INIT: this directory needs to be created manually.
set undodir=~/.vim/undodir
set undofile

" }}}

" EDITING CHANGES {{{

" PRACTICE: Yank to the end of the line instead of the whole line
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
" KLM: disabled because I never use
" nnoremap j gj
" nnoremap k gk

" }}}

" LEADER POWERUPS {{{

" Unhighlight all search results
nnoremap <leader><space> :nohlsearch<CR>

" Toggle between absolute and relative line numbers
" NOTE: l is now used for location list, and I never use this.
" nnoremap <leader>l :call <SID>ToggleNumber()<CR>

" Split horizontal/vertically and start with file search open.
nnoremap <leader>hs :new<CR>:GFiles<CR>
nnoremap <leader>vs :vs<CR>:GFiles<CR>

" Toggle viewing the Undo tree
" PRUNE: rarely use this plugin, but it can be nice.
nnoremap <leader>u :UndotreeToggle<CR>

" Switch files using fuzzy search
nnoremap <leader>s :GFiles<CR>

" Only show changes to file, zr will show 3 lines above/below hunks.
nnoremap <leader>hf :GitGutterFold<CR>zr

" ha = add to stage
" Already use <leader>hs for horizontal split fuzzy open
nmap <Leader>ha <Plug>GitGutterStageHunk

" Mark the current word as "Good" in the spellfile
" Requires spelunker.vim
nmap <leader>g Zg

" Fix the spelling of word under curser (like "I'm feeling lucky")
" Requires spelunker.vim
nmap <leader>k Zf

" Use the Ack plugin to search project files (the Ag plugin is depreciated)
" Using ! makes it not wait for all results before showing any
nnoremap <leader>a :Ack!<space>

" Quickly open file explorer. If use 'Find' then will open at current file.
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>m :NERDTreeToggle<CR>
" PRACTICE (if need to quick jump there)
map <leader>nf :NERDTreeFocus<cr>

" Use ,d (or ,dd or 20,dd) to delete a line without adding it to the yanked buffer
" This also works in in visual mode
" KLM: commented out because I can use "0 to get the previous buffer (that
" wasn't overwritten with a normal d)
" nnoremap <silent> <leader>d "_d
" vnoremap <silent> <leader>d "_d

" Pull word under cursor into LHS of a substitute (for search and replace)
" This uses '#' as a delimiter instead of /
" PRACTICE
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Comment lines of code
nmap <leader>c :TComment<CR>
vmap <leader>c :TComment<CR>
" HACK: To get working in tsx
" autocmd FileType tsx setlocal commentstring="// %s"
" setglobal commentstring="// %s"
" nmap <leader>e :TCommentAs javascript<CR>
" vmap <leader>e :TCommentAs javascript<CR>

" Leader keys mapped from plugins (so I don't overwrite them)
" TODO:

" }}}

" VISUAL MODE {{{

" Keep the current visual block selected after shifting with '<' or '>'.
vmap > >gv
vmap < <gv

" Highlight the last inserted text
" PRACTICE
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
set updatetime=300

" Hack to always display sign column (might not be necessary on nvim)
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

" Sometimes files opened using quickfix window don't detect filetype
" so tie it into the "refresh screen" command.
" KLM: doesn't seem to work, but using :e does.
"nnoremap <C-w> :filetype detect<cr>:redraw!<cr>

" }}}

" SEARCHING {{{

" Highlight all search results
set hlsearch

" Show highlighted results as you type
set incsearch

" Use the current visual selection to search using * and #
" PRACTICE
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" }}}

" BUFFERS & SPLITS {{{

" Hide buffers instead of closing them, this also preserves marks and undo buffers
" (this also has to be set for CoC to work, set it's set again below)
set hidden

" Set default locations for new splits to appear
set splitbelow
set splitright

" Avoid having to press Ctrl-W when navigating or creating new splits.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Show all buffers and then type in number or part of file and hit enter
" KLM: never use anymore, should set up fuzzy search for open buffers instead.
" nnoremap <F5> :ls<CR>:b<Space>


" Open project notes. Use gt to toggle between (goto tab).
" with Vim’s :drop command. With :drop, Vim will open the file if it’s
" not already open, or jump to the open buffer if it is.
" Combine with :tab and we get an even better mapping:
"
" TODO: this doesn't work.
" nmap <script>n<CR> <SID>:tab drop tmp/notes.md<CR>

" }}}

" TAGS {{{

" Use 'tagbar' plugin to show entire file structure
" I commented out this plugin -- I never use it.
" nnoremap <F8> :TagbarToggle<CR>

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
" FIX and PRACTICE
" nnoremap <Space> za

" Mappings to easily toggle fold levels
" PRACTICE
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

" Emojis :)
Plug 'junegunn/vim-emoji'


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
"
" Vim syntax and indent plugin for .vue files. Mainly inspired by mxw/vim-jsx
" KLM: trying to enable for all to see if that fixes the search box
" highlighting being bad :(
" TODO: this seems like an alternative to coc-vetur (having both might be
" causing issues)
" Plug 'leafoftree/vim-vue-plugin', { 'for': ['vue'] }

" For highlighting GraphQL (GQL)
" FIX: doesn't seem to work?
" Plug 'jparise/vim-graphql'

" }}}

" <SYNTAX HIGHLIGHTING & FORMATTING> {{{

" Supports styled-components AND emotion and others
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Better syntax highlighting and formatting, also highlights JSDocs
" Note: this supports Flow but not TypeScript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Add syntax highlighting for JSX in TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Easily align multiple lines (e.g. space around =)
" Plug 'junegunn/vim-easy-align'

" Improved spell checking
Plug 'kamykn/spelunker.vim'
" Needed for spell checking popup
Plug 'kamykn/popup-menu.nvim'

" }}}

" <USER INTERFACE> {{{


" Get a popup with a command for vim commands
" TODO: would love to re-enable this once the error goes away (maybe in future nvim versions)
" Plug 'sudormrfbin/cheatsheet.nvim'
" TODO enabled telescope once I have nvim 0.5+ installed
" Installing Telescope is not required, but highly recommended for using this plugin effectively. popup.nvim and plenary.nvim are used by Telescope.
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'

" Show only the current window having a 'current' line and allow custom coloring if it.
Plug 'miyakogi/conoline.vim'

" Show indentation using vertical bars
Plug 'yggdroot/indentline'

" Make commenting/uncommenting lines easier
Plug 'tomtom/tcomment_vim'

" Show a legit status bar
if !exists('g:started_by_firenvim')
  " Disable vim-airline when firenvim starts since vim-airline takes two lines.
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

" Visualize the undo tree using :UndotreeToggle
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Transform the UI to be better for writing using :Goyo
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

" Remap '.' to allow plugins to tap into it (Unimpaired uses this)
Plug 'tpope/vim-repeat'

" Define more 'text objects' like [ ( <, etc to operate on, e.g. i) will select inside ()
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'bkad/camelcasemotion'
" Plug 'kana/vim-textobj-entire' throws error

" Support for {{ and [[ for syntax highlighting, matching, text object commands, etc
Plug 'mustache/vim-mustache-handlebars', { 'for': ['jinja', 'html'] }

" Map ctrl+<hjkl> to move between panes without conflicting with tmux.
Plug 'christoomey/vim-tmux-navigator'

" Show side-bar when hit ", @, or ^R to see what's in registers.
" KLM: commented out to see if it fixes the 'collapse pane on paste' bug I'm seeing
" Plug 'junegunn/vim-peekaboo'

" Use <leader>l and <leader>q to toggle location and quickfix lists
" FIX (leader l doesn't seem to work, but leader q does)
" PRACTICE
Plug 'valloric/listtoggle'

" Make quickfix and locationlist easier to manage (close if last open or if
" parent closes)
" NOTE: this might conflict with coc or other plugins
Plug 'romainl/vim-qf'


" Open items in quickfix/location based on last focused when hitting enter,
" and add <leader>hs and <leader>vs for opening it in a new split.
" You can select multiple with visual to open them at the same time.
Plug 'yssl/QFEnter'

" Better version than matchit built in plugin (this should auto disable that one)
" match-up is a plugin that lets you highlight, navigate, and operate on sets of matching text.
" It extends vim's % key to language-specific words instead of just single characters.
" (note: for Vue this needs vim-vue-plugin)
" Plug 'andymass/vim-matchup'
"
" KLM: I replaced ^^^ matchup with matchtag, but then I don't get the % to
" jump to another tag. If syntax highlighting still seems broken, then switch
" back to that and figure out why it highlights some closing braces as red.
" enable matchit plugin which ships with vim and greatly enhances '%'
packadd! matchit
Plug 'leafOfTree/vim-matchtag'




" }}}

" <FOLDING> {{{

" Use a better folding algorithm for Python
Plug 'tmhedberg/simpylfold', { 'for': 'python' }

" }}}

" <GENERAL> {{{

" File system explorer
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }

" Three things in one:
"  1) correct commonly misspelled words
"  2) allow capital S for smart case replacements
"  3) provide shortcuts for reformatting casing (crm=coerce to snake_case,
"  cr-=dash-case, cru=upper-case, crt=title case)
" PRACTICE
Plug 'tpope/vim-abolish'

" 20 convenient mappings starting with ] and [
" PRACTICE
Plug 'tpope/vim-unimpaired'

" Require timeout between hjkl presses to practice using better movement commands
Plug 'takac/vim-hardtime'

" Make FocusGained and FocusLost work with tmux. This is important for
" Fugitive and GitGutter plugins
Plug 'tmux-plugins/vim-tmux-focus-events'

" Use nvim in the browser :)
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Enable w!! hack with nvim (this prompts you for password and write)
Plug 'lambdalisue/suda.vim'

" }}}

" <SEARCHING> {{{

" Use 2-character sequence to jump to anywhere in the file
" PRACTICE (high-priority)
Plug 'easymotion/vim-easymotion'
" | Plug 'haya14busa/vim-easyoperator-line'
" | Plug 'aykamko/vim-easymotion-segments'


" Fuzzy search git repo and populate results in change list
" NOTE: Another good fuzzy finder seems to be CTRLP
" https://vimawesome.com/plugin/ctrlp-vim-everything-has-changed
Plug 'mileszs/ack.vim'

" Fuzzy file finder (e.g. :Files, :Commits), works with more than just vim
" INIT: need to install using git clone and install.sh
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'


" }}}

" <TAGS> {{{


" Seems like the best tags manager? This is mostly used for 'go to definition'
" Disabled right now because don't use and it's a bit slow.
" Plug 'ludovicchabant/vim-gutentags'
"
" Could also explore: More robust version of ctags, use C^-] and C^-t to nav
" Plug 'universal-ctags/ctags'

" Auto-generate tags file in local repo while respecting ignore files
" KLM: switch to tim-popes git hooks instead, this isn't working for some reason.
" Plug 'szw/vim-tags'

" Open side-bar showing tag structure in file
" Plug 'majutsushi/tagbar'

" }}}

" <GIT> {{{

" Git wrapper (:Gblame, etc)
" PRACTICE
Plug 'tpope/vim-fugitive'

" Show diffs in gutter and allow you to stage or fold hunks
Plug 'airblade/vim-gitgutter'
"
" }}}

" <EASY INSERT / EDITING> {{{

" Easily insert 'templates' (snippets)
" The 1st is the engine, the 2nd plugin is the actual snippets collection.
" PRACTICE (and look for coc specific plugins instead of these)
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Automatically close () " etc
"Plug 'townk/vim-autoclose'

" Easily surround existing text with quotes / HTML blocks
" PRACTICE
" Plug 'tpope/vim-surround'

" Supports VS-Code plugins for nvim
" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Auto-complete (CoC does this much better)
" Also need to install https://valloric.github.io/YouCompleteMe/#ubuntu-linux-x64
" Plug 'valloric/youcompleteme'

" }}}

" All Plugins must be added before the following line
call plug#end()
" }}}

" PLUGIN CONFIGURATION {{{

" <<< youcompleteme >>>
" -------------------------

" let g:ycm_collect_identifiers_from_tags_files=1
" " Enable language specific identifiers
" let g:ycm_seed_identifiers_with_syntax=1
" let g:ycm_min_num_of_chars_for_completion=3
" let g:ycm_autoclose_preview_window_after_completion=1

" <<< coc.nvim >>>
" -------------------------

"" INIT: install these coc extensions manually using
":CocInstall
"coc-json
"coc-yaml
"coc-css
"coc-prettier
"coc-eslint
"coc-stylelint
"NO --- This is depreciated in favor of eslint coc-tsserver coc-tslint-plugin
"coc-html
"coc-pyright   (a replacement for the depreciated coc-python)
"coc-highlight
"coc-diagnostic (extra linters for shell, markdown, etc)
"coc-vetur   (for Vue)
" Install GQL language server with
"   npm i -g graphql-language-service-cli
" TODO: look into coc-snippets

" NOTE: run
" :CocList extensions (to see list)
" ? means invalid extension
" * means extension is activated
" + means extension is loaded
" - means extension is disabled

" THIS is how you get error on each line, not just on a character
" {
"   diagnostic.checkCurrentLine": true
" }
" coc-settings.json can be found in ~/.vim/coc-settings.json

""" NOTE! vue is a special snowflake for formatOnSaveFiletypes not working
" so need this hack:
" see https://github.com/neoclide/coc-prettier/issues/73 
autocmd BufWritePre *.vue Prettier

" If hidden is not set, TextEdit might fail.
set hidden

" Some server have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" Don't give |ins-completion-menu| messages.
set shortmess+=c

" Always show signcolumns
set signcolumn=yes

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
" PRUNE
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" sd = show diagnostic (part of coc)
nmap sd <Plug>(coc-diagnostic-info)

" let g:node_client_debug = 1

" Use K for show documentation in preview window
" PRACTICE
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile


" <<< diminactive >>>
" -------------------------

" Disable syntax highlighting if not active
" KLM: note doesn't work but instead removes all color
" let g:diminactive_use_syntax=1

" Tie in with Vim's unfocus event to dim on that too.
" Note: required tmux-focus-events plugin to work with tmux.
" KLM: note this doesn't work..
" let g:diminactive_enable_focus=1


" <<< vim-emoji >>>
" -------------------------
set completefunc=emoji#complete


" <<< listtoggle >>>
" -------------------------

let g:lt_location_list_toggle_map='<leader>l'
let g:lt_quickfix_list_toggle_map='<leader>q'
" Set height of list
let g:lt_height=10

" <<< QFEnter >>>
" -------------------------

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<Leader>vs']
let g:qfenter_keymap.hopen = ['<Leader>hs']
" let g:qfenter_keymap.topen = ['<Leader><Tab>']


" <<< vim-airline >>>
" -------------------------

set laststatus=2
" Theme set by gruvbox
" let g:airline_theme='zenburn'
let g:airline_left_sep=''
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_right_sep=''


" <<< firenvim >>>
" -------------------------

if exists('g:started_by_firenvim') && g:started_by_firenvim
  " Default local and global settings. Overwritten below for some sites.
  " Changed: 'takeover: always': to 'once'
  let g:firenvim_config = {
        \ 'globalSettings': {
            \ 'alt': 'all',
            \ 'cmdlineTimeout': 3000,
        \  },
        \ 'localSettings': {
            \ '.*': {
                \ 'cmdline': 'neovim',
                \ 'content': 'text',
                \ 'priority': 0,
                \ 'selector': 'textarea',
                \ 'takeover': 'never',
            \ },
        \ }
    \ }
  let fc = g:firenvim_config['localSettings']
  let fc['https?://.*roamresearch.com'] = { 'takeover': 'never', 'priority': 1 }
  " let fc['https?://.*github.com'] = { 'takeover': 'never', 'priority': 1 }
  let fc['https?://mail.google.com'] = { 'takeover': 'never', 'priority': 1 }

  " Keep in sync with underlying element.
  " Sometimes this does weird things
  " au TextChanged * ++nested write
  " au TextChangedI * ++nested write

  " general options
  set laststatus=0 nonumber noruler noshowcmd

  augroup firenvim
    autocmd!

    autocmd BufEnter *.txt setlocal filetype=markdown.pandoc
    " Treat browser text entries as markdown formatting
    "au BufEnter github.com_*.txt set filetype=markdown

    " This is run before writing the whole buffer to a file.
    " (BufWritePost doesn't work, and BufWriteCmd makes it so the plugin doesnt exit because
    " it gets and error that the match doesnt exist (even with /ge)
    autocmd BufWrite * %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/ge
  augroup END
endif


" <<< vim-hardtime >>>
" -------------------------

let g:hardtime_timeout=500
let g:hardtime_default_on=1
let g:hardtime_showmsg=1
let g:hardtime_ignore_quickfix=1
let g:hardtime_allow_different_key=1
let g:hardtime_maxcount=3

" <<< vim-fugitive >>>
" -------------------------

" Solving merge conflicts.
" See https://medium.com/prodopsio/solving-git-merge-conflicts-with-vim-c8a8617e3633
" and http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/

" Fugitive Conflict Resolution
" NOTE: gc stands for git compare (since I already use gd for go to definition)
" Jumping to the next git hunk (or conflict to fix) can be done with [c to backward or ]c to search forward
" When you are satisfied with your workspace (usually when all conflicts are resolved) it’s time to leave just
" this pane open; we can do that with <C-w>o which tells VIM’s window manager to leave the current pane only.
" Left = target branch (you're current branch)
" Right = merge branch (what's being merged in)
" To keep a change wholesale, go to that tab and run :Gwrite!
nnoremap <leader>gc :Gvdiff<CR>
" The 'h' is for left and the 'l' is for right
" PRACTICE
nnoremap gch :diffget //2<CR>
nnoremap gcl :diffget //3<CR>

" PRACTICE
command! Greview :Git! diff --staged
nnoremap <leader>gr :Greview<cr>


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
" KLM: disabled TAB to use in coc autocomplete
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"
" <<< gutentags >>>
" -------------------------

" See this:
" https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/

" let g:gutentags_add_default_project_roots = 0
" let g:gutentags_project_root = ['package.json', '.git']
"
" let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
"
" USE THIS TO CLEAR THE TAG CACHE
" command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" let g:gutentags_generate_on_new = 1
" let g:gutentags_generate_on_missing = 1
" let g:gutentags_generate_on_write = 1
" let g:gutentags_generate_on_empty_buffer = 0

" Let Gutentags generate more info for the tags.
" Explaining --fields=+ailmnS (info gathered from: $ ctags --list-fields)
" a: Access (or export) of class members
" i: Inheritance information
" l: Language of input file containing tag
" m: Implementation information
" n: Line number of tag definition
" S: Signature of routine (e.g. prototype or parameter list)
" let g:gutentags_ctags_extra_args = [
"       \ '--tag-relative=yes',
"       \ '--fields=+ailmnS',
"       \ ]
"
" let g:gutentags_ctags_exclude = [
"       \ '*.git', '*.svg', '*.hg',
"       \ '*/tests/*',
"       \ 'build',
"       \ 'dist',
"       \ '*sites/*/files/*',
"       \ 'bin',
"       \ 'node_modules',
"       \ 'bower_components',
"       \ 'cache',
"       \ 'compiled',
"       \ 'docs',
"       \ 'example',
"       \ 'bundle',
"       \ 'vendor',
"       \ '*.md',
"       \ '*-lock.json',
"       \ '*.lock',
"       \ '*bundle*.js',
"       \ '*build*.js',
"       \ '.*rc*',
"       \ '*.json',
"       \ '*.min.*',
"       \ '*.map',
"       \ '*.bak',
"       \ '*.zip',
"       \ '*.pyc',
"       \ '*.class',
"       \ '*.sln',
"       \ '*.Master',
"       \ '*.csproj',
"       \ '*.tmp',
"       \ '*.csproj.user',
"       \ '*.cache',
"       \ '*.pdb',
"       \ 'tags*',
"       \ 'cscope.*',
"       \ '*.css',
"       \ '*.less',
"       \ '*.scss',
"       \ '*.exe', '*.dll',
"       \ '*.mp3', '*.ogg', '*.flac',
"       \ '*.swp', '*.swo',
"       \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
"       \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
"       \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
"       \ ]



" <<< ctags >>>
" -------------------------

" Look for tag file in current directory, otherwise look for .git/tags
" until hit HOME (that's what semi-colon does)
" set tags=tags;~


" <<< vim-easymotion >>>
" -------------------------

 " Disable default mappings
let g:EasyMotion_do_mapping=0

" Need one more keystroke, but on average, it may be more comfortable.
"map <Space> <Plug>(easymotion-overwin-f2)
" PRACTICE
map <leader><leader> <Plug>(easymotion-bd-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase=1


" <<< nerdtree >>>
" -------------------------

let g:NERDTreeWinPos="right"
let NERDTreeShowHidden=0
let g:NERDTreeWinSize=35

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
" These prevents conceallevel being changed which messes with quotes
let g:indentLine_fileTypeExclude = ['json']


" <<< ack >>>
" -------------------------

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg='ag --vimgrep -Q'
endif

" Search word under cursor
" This is at the bottom to overwrite coc mapping for leader f.
nnoremap <Leader>f :Ack! <cword><cr>

" When you press gv you Ack after the selected text
" vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" When you press <leader>r you can search and replace the selected text
" vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

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

" Enable 256 colors in nvim
set termguicolors

" Requires gruvbox plugin
" NOTE: this must be set AFTER the plugin section to work.
let g:gruvbox_italic=1
colorscheme gruvbox

" }}}

" SPELLING {{{

" NOTE: this was replaced with spelunker plugin which does
" spell checking that accounts for camel/snake case.
" Enable spellcheck. Use z= to see spelling suggestions
" set spell spelllang=en_us


" Try to disable because it's slow -- TOGGLE THESE TOGETHER
let g:enable_spelunker_vim = 0
" spelunker does spellcheck, so don't want to mark it twice.
" set nospell
" set spell
" set spell spelllang=en_us

" Note: spelunker doesn't currently run on new files or git messages.
" This turns on spelling just for commit messages until I can figure this out.
autocmd FileType gitcommit let g:enable_spelunker_vim = 1

if !g:enable_spelunker_vim
  " echom 'Not set'
  " " Show misspelled words in bold
  " " NOTE: this must must after colorscheme for bold to work correctly.
  hi clear SpellBad
  hi SpellBad cterm=bold
  hi clear SpellRare
  hi clear SpellCap
  hi SpellCap cterm=bold
  hi clear SpellLocal
  hi SpellLocal cterm=bold
endif

" 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
" depends on the setting of CursorHold `set updatetime=1000`.
let g:spelunker_check_type = 2

highlight SpelunkerSpellBad cterm=bold
highlight SpelunkerComplexOrCompoundWord cterm=bold

set spellfile=~/dotfiles/klm.en.utf-8.add

" }}}
"
" I changed this from 0 to 1000 because doing a ciw (change in word) would
" really mess things up for some reason.
" vim:foldmethod=marker:foldlevel=1000
"
