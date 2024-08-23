call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/AutoComplPop'
call plug#end()

let g:fzf_layout = {'down':'40%'}
colorscheme morning
set number
set clipboard+=unnamedplus
