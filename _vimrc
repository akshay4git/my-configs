" === Compile & Run C++ on Windows ===
nnoremap <F5> :w<CR>:!g++ -std=c++17 -Wall -Wextra "%:p" -o "%:p:r.exe" && "%:p:r.exe"<CR>

" Leader + F6 or just F6 to compile and run with input redirection
"nnoremap <F6> :w<CR>:!g++ -std=c++17 -Wall -Wextra % -o %:r.exe && cmd /c %:r.exe ^< input.txt<CR>


"---GENERAL---
syntax on
set number
set relativenumber
set tabstop=4 shiftwidth=4 expandtab

let mapleader = " "
nnoremap <Leader>ee :Ex<CR>

set guifont=Courier_New:h14:b


call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

set laststatus=2

" === Lightline Theme and Sections ===
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['readonly', 'filename', 'modified'] ]
      \ },
      \ 'inactive': {
      \   'left': [ ['filename'] ],
      \   'right': [ ['lineinfo'] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ }
      \ }

" === Show just the filename ===
function! LightlineFilename()
  return expand('%:t') !=# '' ? expand('%:t') : '[No File]'
endfunction

