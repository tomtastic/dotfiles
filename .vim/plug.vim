" ----------------------------------------------------------------------------
"   Plug
" ----------------------------------------------------------------------------

" Install vim-plug if we don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'captbaritone/molokai'
Plug 'ajh17/spacegray.vim'
Plug 'morhetz/gruvbox'
Plug 'fatih/molokai'

" Fancy statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Show git status in the gutter
Plug 'airblade/vim-gitgutter'

" Lets get syntastical
Plug 'vim-syntastic/syntastic'
Plug 'pearofducks/ansible-vim'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }


filetype plugin indent on                   " required!
call plug#end()


