lua require('plugins')
lua require('snippets')

set encoding=utf-8
scriptencoding utf-8
filetype plugin indent on

let g:neoformat_cpp_clangformat = {
    \ 'exe': 'clang-format',
    \ 'args': ['-style=google'],
    \ 'stdin': 1,
    \ }
let g:neoformat_python_yapf = {
    \ 'exe': 'yapf',
    \ 'args': ['--style google'],
    \ 'stdin': 1,
    \ }
let g:neoformat_java_googlefmt = {
    \ 'exe': 'java-format',
    \ 'args': ['-'],
    \ 'stdin': 1,
    \ }
let g:neoformat_lua_stylua = {
    \ 'exe': 'stylua',
    \ 'args': ['--column-width 80', '--indent-type Spaces',
    \          '--indent-width 2', '--quote-style AutoPreferSingle',
    \          '--call-parentheses None', '-'],
    \ 'stdin': 1,
    \ }
let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']
let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_java = ['googlefmt']
let g:neoformat_enabled_lua = ['stylua']
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:asyncrun_save = 2

let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDDefaultAlign = 'left'

let g:suda_smart_edit = 1
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }

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
set timeoutlen=500
set signcolumn=yes
set sessionoptions+=options,resize,winpos,terminal
if (has("termguicolors"))
  set termguicolors
endif
" set spell
" set spelllang=en_us

command! -nargs=0 RunCode call RunCode()
command! -nargs=0 ToggleHLSearch call ToggleHLSearch()

silent autocmd BufWritePost plugins.lua source <afile> | PackerCompile
silent autocmd BufWritePre * Neoformat
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
  execute 'write'
  let path = expand('%:p')
  let name = expand('%:t:r')
  if &filetype == 'cpp'
    " call asyncrun#run('', {},
    "     \ 'clang++ $VIM_FILEPATH -O2 -o $VIM_FILENOEXT; $VIM_PATHNOEXT')
    let command = 'clang++ ' . path . ' -O2 -o ' . name . ' && ./' . name . "\n"
  elseif &filetype == 'c'
    " call asyncrun#run('', {},
    "     \ 'clang $VIM_FILEPATH -O2 -o $VIM_FILENOEXT; $VIM_PATHNOEXT')
    let command = 'clang ' . path . ' -O2 -o ' . name . ' && ./' . name . "\n"
  elseif &filetype == 'python'
    " call asyncrun#run('', {},
    "     \ 'python3 $VIM_FILEPATH')
    let command = 'python3 ' . path . "\n"
  elseif &filetype == 'java'
    " call asyncrun#run('', {},
    "     \ 'javac $VIM_FILEPATH; java $VIM_FILENOEXT')
    let command = 'javac ' . path . ' && java ' . name . "\n"
  else
    return
  endif
  execute 'terminal'
  call jobsend(b:terminal_job_id, command)
  normal i
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
