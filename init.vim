call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

Plug 'mbbill/undotree'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv'
Plug 'dense-analysis/ale'
Plug 'szw/vim-tags'
Plug 'vinsonchuong/vim-stdtabs'
Plug 'sheerun/vim-polyglot'

Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'markcornick/vim-bats'

Plug 'kana/vim-textobj-user'
Plug 'thinca/vim-textobj-between'
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-entire'
Plug 'whatyouhide/vim-textobj-erb'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-line'
Plug 'sgur/vim-textobj-parameter'
Plug 'saaguero/vim-textobj-pastedtext'
Plug 'kana/vim-textobj-syntax'
Plug 'whatyouhide/vim-textobj-xmlattr'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'jiangmiao/auto-pairs'
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim'

call plug#end()

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $FZF_DEFAULT_OPTS='--color=16'

set nowrap
set number
set numberwidth=5
set undofile
set backupcopy=yes
set diffopt+=vertical
set foldmethod=syntax

colorscheme solarized
set background=light
let g:lightline={'colorscheme': 'solarized'}
let g:markdown_fenced_languages=['sh', 'erb=eruby', 'js=javascript']

let g:suda_smart_edit=1

let g:fzf_layout={'window': 'enew'}
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'gutter':  ['bg', 'Normal'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_preview_window=[]

let g:test#javascript#ava#file_pattern='\v\.test\.js$'
let g:ale_fixers={
  \ 'javascript': ['xo']
\ }
let g:ale_linters={
  \ 'javascript': ['xo', 'tsserver']
\ }

let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

let mapleader="\<Space>"
nnoremap <Leader>f :GitFiles<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :Git<CR>
nnoremap <Leader>t :TestFile<CR>
nnoremap <Leader>T :TestSuite<CR>
