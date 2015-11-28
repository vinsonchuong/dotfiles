call plug#begin()
Plug 'junegunn/vim-plug', {'do': 'ln -sf $(realpath plug.vim) ~/.vim/autoload'}
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'

Plug 'tpope/vim-sensible'
Plug 'rstacruz/vim-opinion'
Plug 'wincent/terminus'
call plug#load('vim-sensible', 'vim-opinion', 'terminus')

Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe', {'do': './install.sh'}
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-speeddating'
Plug 'bronson/vim-visual-star-search'

Plug 'tpope/vim-eunuch'
Plug 'rking/ag.vim'
Plug 'tpope/vim-unimpaired'

Plug 'tpope/vim-vinegar'
Plug 'Shougo/unite.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'
Plug 'godlygeek/tabular'
Plug 'AndrewRadev/splitjoin.vim'

Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-syntax'

Plug 'tpope/vim-dispatch'
Plug 'scrooloose/syntastic'
Plug 'szw/vim-tags'
Plug 'sdanielf/vim-stdtabs'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
call plug#end()

colorscheme solarized
set noshowmode
set undofile
set undodir=$HOME/.vim/undo

let mapleader="\<Space>"
nnoremap <Leader>f :Unite -no-split -hide-source-names -start-insert file_rec/git file/new<CR>
nnoremap <Leader>l :Unite -no-split -hide-source-names -start-insert script:/bin/bash:/home/vinsonchuong/projects/unite-scripts/licenses<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :tab split README.md \| Gstatus<CR>
nnoremap <Leader>m :Make<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>

let g:lightline = {'colorscheme': 'solarized_light'}

let g:unite_cursor_line_highlight='CursorLine'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])

"let g:ycm_show_diagnostics_ui=1
let g:ycm_collect_identifiers_from_tags_files=0
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_key_invoke_completion=''
let g:ycm_key_detailed_diagnostics=''

let g:UltiSnipsExpandTrigger='<C-]>'
let g:UltiSnipsJumpForwardTrigger='<C-]>'
let g:UltiSnipsJumpBackwardTrigger='<Nop>'
let g:UltiSnipsListSnippets='<Nop>'

let g:syntastic_enable_signs=0
let g:syntastic_enable_highlighting=0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1

let g:markdown_fenced_languages=['sh', 'erb=eruby', 'js=javascript']

autocmd FileType sh setlocal noet
autocmd FileType zsh setlocal noet
autocmd FileType ruby nnoremap <buffer> <C-m> :Rrunner<CR>
autocmd BufWritePost * silent Git add -N %
