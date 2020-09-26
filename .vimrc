" ----------------------------------------------------------------------------
"   .vimrc
" ----------------------------------------------------------------------------

" Allow vim to break compatibility with vi
set nocompatible " This must be first, because it changes other options

" ----------------------------------------------------------------------------
"   Plugin
" ----------------------------------------------------------------------------

" Installing the Plug plugin manager, and all the plugins are included in this
" other file.
source $HOME/.vim/plug.vim

" ----------------------------------------------------------------------------
"   Base options
" ----------------------------------------------------------------------------

set encoding=utf-8              " I generally want utf-8 encoding
set ttyfast                     " Indicates a fast terminal connection

" ----------------------------------------------------------------------------
"   Visual
" ----------------------------------------------------------------------------


" Control Area (May be superseded by vim-airline)
set showcmd                 " Show (partial) command in the last line of the screen.
set wildmenu                " Command completion
set wildmode=list:longest   " List all matches and complete till longest common string
set laststatus=2            " The last window will have a status line always
set noshowmode              " Don't show the mode in the last line of the screen, vim-airline takes care of it
set ruler                   " Show the line and column number of the cursor position, separated by a comma.
set lazyredraw              " Don't update the screen while executing macros/commands

" My command line autocomplete is case insensitive. Keep vim consistent with
" that. It's a recent feature to vim, test to make sure it's supported first.
if exists("&wildignorecase")
    set wildignorecase
endif

" Buffer Area Visuals
set scrolloff=7             " Minimal number of screen lines to keep above and below the cursor.
set visualbell              " Use a visual bell, don't beep!
set cursorline              " Highlight the current line
set number                  " Show line numbers
"set wrap                    " Soft wrap at the window width
"set linebreak               " Break the line on words
set textwidth=79            " Break lines at just under 80 characters
if exists('+colorcolumn')
  set colorcolumn=+1,100        " Highlight the column after `textwidth`
endif
set numberwidth=4           " Width of the line number column

" show fold column, fold by markers
set foldcolumn=0            " Don't show the folding gutter/column
set foldmethod=marker       " Fold on {{{ }}}
set foldlevelstart=20       " Open 20 levels of folding when I open a file

" Open folds under the following conditions
set foldopen=block,hor,mark,percent,quickfix,search,tag,undo,jump

" Highlight tabs and trailing spaces
set listchars=tab:▸\ ,trail:•
set list                    " Make whitespace characters visible

" Splits
set splitbelow              " Open new splits below
set splitright              " Open new vertical splits to the right

" Character meaning when present in 'formatoptions'
" ------ ---------------------------------------
" c Auto-wrap comments using textwidth, inserting the current comment leader automatically.
" q Allow formatting of comments with "gq".
" r Automatically insert the current comment leader after hitting <Enter> in Insert mode.
" t Auto-wrap text using textwidth (does not apply to comments)
" n Recognize numbered lists
" 1 Don't break line after one-letter words
" a Automatically format paragraphs
set formatoptions=cqrn1

" Colors
syntax enable               " This has to come after colorcolumn in order to draw it.
set t_Co=256                " enable 256 colors

" GruvBox tweaks
let g:gruvbox_contrast_dark='hard'
set background=dark    " Setting dark mode
"set background=light   " Setting light mode

" Molokai tweaks
let g:rehash256 = 1
let g:molokai_original = 1

colorscheme gruvbox
"colorscheme molokai
"colorscheme spacegray

let g:airline_theme='zenburn'

" When completing, fill with the longest common string
" Auto select the first option
set completeopt=longest,menuone

" Printing options
set printoptions=header:0,duplex:long,paper:letter,syntax:n
" header:0                  Do not print a header
" duplex:long (default)     Print on both sides (when possible), bind on long
" syntax:n                  Do not use syntax highlighting.

" }}}-------------------------------------------------------------------------
"   Style for terminal vim
" ----------------------------------------------------------------------------

" Don't show the airline separators
" The angle bracket defaults look fugly
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_powerline_fonts=0
"set mouse+=a  " Add mouse support for 'all' modes, may require iTerm
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" }}}-------------------------------------------------------------------------
"   Search                                                                {{{
" ----------------------------------------------------------------------------

set incsearch               " Show search results as we type
set showmatch               " Show matching brackets
set hlsearch                " Highlight search results
set ignorecase              " Ignore case when searching
set smartcase               " Don't ignore case if we have a capital letter

" }}}-------------------------------------------------------------------------
"   Tabs                                                                  {{{
" ----------------------------------------------------------------------------

set tabstop=4               " Show a tab as four spaces
set shiftwidth=4            " Reindent is also four spaces
set softtabstop=4           " When hit <tab> use four columns
set expandtab               " Create spaces when I type <tab>
set shiftround              " Round indent to multiple of 'shiftwidth'.
set autoindent              " Put my cursor in the right place when I start a new line
"filetype plugin indent on   " Rely on file plugins to handle indenting

" }}}-------------------------------------------------------------------------
"   Custom commands                                                       {{{
" ----------------------------------------------------------------------------

" Edit the vimrc file
nmap <silent> <Leader>ev :vsplit $MYVIMRC<CR>
nmap <silent> <Leader>ez :vsplit $HOME/.zshrc<CR>
nmap <silent> <Leader>ep :vsplit $HOME/.vim/plug.vim<CR>
nmap <silent> <Leader>es :vsplit $HOME/.ssh/config<CR>
nmap <silent> <Leader>et :vsplit $HOME/.tmux.conf<CR>
nmap <silent> <Leader>sv :source $MYVIMRC<CR>
nmap <silent> <Leader>sp :source $HOME/.vim/plug.vim<CR>

" Faster save/quite/close
nmap <silent> <Leader>w :update<CR>
nmap <silent> <Leader>q :quit<CR>
nmap <silent> <Leader>c :bdelete<CR>
nmap <silent> <Leader>n :cnext<CR>
nmap <silent> <Leader>p :cprevious<CR>

" Cd to the current file's directory
nnoremap <Leader>. :cd %:p:h<CR>:pwd<CR>

" Move current window to the far left using full height
nmap <silent> <Leader>h <C-w>H
" Move current window to the far right using full height
nmap <silent> <Leader>l <C-w>L
" Move current window to the top using full width
nmap <silent> <Leader>k <C-w>K
" Move current window to the bottom using full width
nmap <silent> <Leader>j <C-w>J

nmap <silent> <Leader>d :YcmCompleter GoToDefinition<CR>

nnoremap <leader>pp :%!python -m json.tool<cr>
nmap <leader>vv :!pandoc -t html -T 'Pandoc Generated - "%"' --standalone --self-contained --data-dir %:p:h --metadata pagetitle="%" -c ~/src/dotfiles/css/pandoc.css "%" \|bcat<cr><cr>


" }}}-------------------------------------------------------------------------
"   Configure My Plugins                                                  {{{
" ----------------------------------------------------------------------------

" Jump thought errors with :lnext and :lprev
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers=['perl']
let g:syntastic_python_checkers=['pylint','python']
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_yaml_checkers=['yamllint']
let g:syntastic_yaml_yamllint_args="-d '{extends: default, rules: {line-length: {max: 100}}}'"
let g:syntastic_sh_checkers=['sh','shellcheck']
let g:syntastic_go_checkers=['go','gofmt','govet']
"let g:syntastic_go_checkers=['golint','errcheck']
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_javascript_eslint_generic = 1

" vim-go tweaks
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_addtags_transform = "camelcase"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_sameids = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
"let g:go_auto_type_info = 1
"set updatetime=400

" Return to last edit position when opening files, except git commit message
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Gist Vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Ctrl-P
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|sass-cache|pip_download_cache|wheel_cache)$',
    \ 'file': '\v\.(png|jpg|jpeg|gif|DS_Store|pyc)$',
    \ 'link': '',
    \ }
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 0
" Wait to update results (This should fix the fact that backspace is so slow)
let g:ctrlp_lazy_update = 1
" Show as many results as our screen will allow
let g:ctrlp_match_window = 'max:1000'

" CtrlP like mapings for opening quick fixes in new splits
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_topen_map = ['<C-t>']

" If we have The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --hidden --ignore "\.git$\|\.hg$\|\.svn|\.pyc$"'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" Undotree plugin.
nnoremap <F5> :UndotreeToggle<CR>

" Jedi Python Autocomplete
let g:jedi#use_tabs_not_buffers = 0 " Jedi needs you to unset this default to get to splits
let g:jedi#use_splits_not_buffers = "bottom"

" }}}-------------------------------------------------------------------------
"   Custom filetypes                                                      {{{
" ----------------------------------------------------------------------------

" Auto detect filetype
autocmd BufRead,BufNewFile *.md,*.markdown set filetype=markdown
autocmd BufRead,BufNewFile *.lytex set filetype=tex
autocmd BufRead,BufNewFile ~/ssh/config set filetype=sshconfig
autocmd BufRead,BufNewFile *.git/config,.gitconfig,.gitmodules,gitconfig set ft=gitconfig
autocmd BufNewFile,BufRead *.html set filetype=htmldjango
autocmd BufNewFile,BufRead .eslintrc set filetype=javascript
autocmd BufNewFile,BufRead *.es6 set filetype=javascript
autocmd BufRead,BufNewFile *.py setlocal foldmethod=indent
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" Override what is done in /vim/bundle/scss-syntax.vim/ftdetect/scss.vim
" This should prevent duplicate snippets
autocmd BufRead,BufNewFile *.scss set filetype=scss

" }}}-------------------------------------------------------------------------
"   Custom mappings                                                       {{{
" ----------------------------------------------------------------------------

" When pasting, refill the default register with what you just pasted
xnoremap p pgvy

" Repurpose arrow keys to navigating windows
nnoremap <left> <C-w>h
nnoremap <right> <C-w>l
nnoremap <up> <C-w>k
nnoremap <down> <C-w>j
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" To encourage the use of <C-[np]> instead of the arrow keys in ex mode, remap
" them to use <Up/Down> instead so that they will filter completions
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Navigate using displayed lines not actual lines
nnoremap j gj
nnoremap k gk

" Make Y consistent with D
nnoremap Y y$

" Reselect visual block after indent/outdent: http://vimbits.com/bits/20
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Allow saving of files as sudo when I forgot to start vim using sudo.
" Seems to have a problem where Vim sees that the file has changed and tries to
" reload it. When it does it thinks the file is blank (but it's not really).
cmap w!! %!sudo tee > /dev/null %

" Do what my fat fingers mean!
command! Bd bd
command! BD bd
command! Q q
command! W w
command! Cn cn
command! Cp cp

" Nobody ever uses "Ex" mode, and it's annoying to leave
noremap Q <nop>

autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <Leader>c  <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>i  <Plug>(go-info)

" }}}-------------------------------------------------------------------------
"   If there is a per-machine local .vimrc, source it here at the end     {{{
" ----------------------------------------------------------------------------

if filereadable(glob("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif

" }}}-------------------------------------------------------------------------
"                                                                         {{{
" ----------------------------------------------------------------------------

let g:jekyll_post_extension = '.md'

command! Py :!python %
command! O :!open %

let g:ag_working_path_mode="r"

set exrc
set secure

