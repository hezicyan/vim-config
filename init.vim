lua require('plugins')
lua require('snippets')

set encoding=utf-8
scriptencoding utf-8
filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')
Plug 'Chiel92/vim-autoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'skywind3000/asyncrun.vim'
Plug 'djoshea/vim-autoread'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'lambdalisue/suda.vim'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
call plug#end()

let g:formatdef_clang_format = '"clang-format -style=google"'
let g:formatdef_yapf = '"yapf --style google"'
let g:formatdef_google_java_format = '"java-format -"'
let g:formatters_cpp = ['clang_format']
let g:formatters_c = ['clang_format']
let g:formatters_python = ['yapf']
let g:formatters_java = ['google_java_format']
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

let g:asyncrun_save = 2

let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDDefaultAlign = 'left'

let g:suda_smart_edit = 1

let g:nvim_tree_git_hl = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }

set number
set relativenumber
set cursorline
set cursorlineopt=number
set showcmd
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set wildmenu
set wildmode=longest:list,full
set mouse=a
set hidden
set nobackup
set nowritebackup
set completeopt=menuone,noselect
set shortmess+=c
set updatetime=100
set signcolumn=yes
set sessionoptions+=options,resize,winpos,terminal
if (has("termguicolors"))
  set termguicolors
endif
" set spell
" set spelllang=en_us

" 透明化方案一
" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme *
"       \ call onedark#set_highlight("Normal", { "fg": s:white })
"   augroup END
" endif
" colorscheme onedark
" 透明化方案二
" highlight StatusLine guibg=NONE ctermbg=NONE
" highlight Normal guibg=NONE ctermbg=NONE 
" highlight LineNr guibg=NONE ctermbg=NONE 
" highlight SignColumn guibg=NONE ctermbg=NONE 
" highlight EndOfBuffer guibg=NONE ctermbg=NONE 

command! -nargs=0 RunCode call RunCode()
command! -nargs=0 ToggleHLSearch call ToggleHLSearch()

nnoremap <C-L> :Autoformat<CR>
nnoremap <C-E> :NvimTreeToggle<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <F5> :call RunCode()<CR>
nnoremap n :set hlsearch<CR>n
nnoremap N :set hlsearch<CR>N
nnoremap / :set hlsearch<CR>/
nnoremap ? :set hlsearch<CR>?
nnoremap * :set hlsearch<CR>*
nnoremap # :set hlsearch<CR>#
nnoremap <C-H> :ToggleHLSearch<CR>

silent autocmd BufWritePost plugins.lua source <afile> | PackerCompile
silent autocmd BufWrite * :Autoformat
silent autocmd BufNewFile * call s:set_header()
silent autocmd FileType * call s:set_indent()
silent autocmd FileType * call s:set_colorcolumn()

function ToggleHLSearch()
  if &hlsearch == 0
    set hlsearch
  else
    set nohlsearch
  endif
endfunction

function RunCode()
  if &filetype == 'cpp'
    call asyncrun#run('', {},
        \ 'clang++ $VIM_FILEPATH -O2 -o $VIM_FILENOEXT; $VIM_PATHNOEXT')
  elseif &filetype == 'c'
    call asyncrun#run('', {},
        \ 'clang $VIM_FILEPATH -O2 -o $VIM_FILENOEXT; $VIM_PATHNOEXT')
  elseif &filetype == 'python'
    call asyncrun#run('', {},
        \ 'python3 $VIM_FILEPATH')
  elseif &filetype == 'java'
    call asyncrun#run('', {},
        \ 'javac $VIM_FILEPATH; java $VIM_FILENOEXT')
  endif
endfunction

function s:check_back_space()
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

function s:set_header()
  if &filetype == 'python'
    call setline(1, '#!/usr/bin/env python3')
    call setline(2, '# -*- coding: utf-8 -*-')
  elseif &filetype == 'sh'
    call setline(1, '#!/usr/bin/env bash')
  elseif &filetype == 'zsh'
    call setline(1, '#!/usr/bin/env zsh')
  endif
  normal G
endfunction

function s:set_indent()
  if index(['cpp', 'c', 'java', 'json', 'jsonc',
          \ 'sh', 'zsh', 'vim', 'lua'], &filetype) >= 0
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
  elseif index(['python'], &filetype) >= 0
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
  else
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
  endif
endfunction

function s:set_colorcolumn()
  if index(['cpp', 'c', 'python', 'json', 'jsonc',
          \ 'sh', 'zsh', 'vim', 'markdown', 'lua'], &filetype) >= 0
    set colorcolumn=81
  elseif index(['java'], &filetype) >= 0
    set colorcolumn=101
  else
    set colorcolumn=
  endif
endfunction
