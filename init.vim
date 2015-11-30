let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

Plug 'mbbill/undotree'
Plug 'Shougo/unite.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv'
Plug 'Valloric/YouCompleteMe', {'do': './install.sh'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/syntastic'
Plug 'szw/vim-tags'
Plug 'vinsonchuong/vim-stdtabs'
Plug 'sheerun/vim-polyglot'

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

Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
call plug#end()

set nowrap
set number
set numberwidth=5
set undofile

colorscheme solarized
let g:lightline={'colorscheme': 'solarized_light'}

let g:unite_cursor_line_highlight='CursorLine'
"let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])

let g:markdown_fenced_languages=['sh', 'erb=eruby', 'js=javascript']

let mapleader="\<Space>"
nnoremap <Leader>f :Unite -no-split -hide-source-names -start-insert file_rec/neovim file/new<CR>
nnoremap <Leader>l :Unite -no-split -hide-source-names -start-insert script:/bin/bash:/home/vinsonchuong/projects/unite-scripts/licenses<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :tab split README.md \| Gstatus<CR>
