call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'mattn/emmet-vim'
call plug#end()

nnoremap fzf :Files<CR>
nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>

let g:fzf_layout = {'down':'40%'}
colorscheme morning
set number
set relativenumber
set shiftwidth=2
set autoindent
set smartindent
set noswapfile

nnoremap <Leader>n :call CreateNewFileOrFolder()<CR>

function! CreateNewFileOrFolder()
  let name = input('Enter file/folder path (end with / for folder): ')
  if name != ''
    let full_path = expand('%:p:h') . '/' . name
    let dir_path = fnamemodify(full_path, ':h')
    
    " Create parent directories if they don't exist
    if !isdirectory(dir_path)
      call mkdir(dir_path, 'p')
      echo 'Created directory: ' . dir_path
    endif
    
    if name[-1:] == '/'
      " It's a folder
      if !isdirectory(full_path)
        call mkdir(full_path, 'p')
        echo 'Created folder: ' . full_path
      else
        echo 'Folder already exists: ' . full_path
      endif
    else
      " It's a file
      if !filereadable(full_path)
        execute 'edit ' . full_path
        write
        echo 'Created new file: ' . full_path
      else
        echo 'File already exists: ' . full_path
        let open_existing = input('Open existing file? (y/n): ')
        if open_existing ==? 'y'
          execute 'edit ' . full_path
        endif
      endif
    endif
  endif
endfunction

if executable('pylsp')
  au User lsp_setup call lsp#register_server({
	\ 'name': 'pylsp',
	\ 'cmd': {server_info->['pylsp']},
	\ 'allowlist': ['python'],
	\ })
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references) 
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'allowlist': ['*'],
      \ 'blocklist': ['go'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
      \    'max_buffer_size': 5000000,
      \  },
      \ }))



au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))
