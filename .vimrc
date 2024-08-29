call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/AutoComplPop'
Plug 'tpope/vim-commentary'
call plug#end()

nnoremap fzf :Files<Cr>
let g:fzf_layout = {'down':'40%'}
colorscheme morning
set number
set relativenumber

