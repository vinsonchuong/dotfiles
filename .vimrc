" ## References
" * http://vimrcfu.com - directory of snippets
" * http://vimawesome.com - directory of popular plugins
" ## To-Do
" * See if tpope/vim-flagship can replace airline
" * Investigate default completion features
"   * Maybe no need for plugins
"   * http://usevim.com/2012/07/06/vim101-completion/
" * Configure netrw
"   * http://usevim.com/2015/06/05/netrw-style/
" * Use rubocop for Ruby in syntastic
" * Suppress YouCompleteMe errors - vim-scripts/noerrmsg.vim
" * Find plugins for extractions and refactorings
" * Investigate offline documentation
"   * https://zealdocs.org
"   * Thibaut/devdocs
"   * Keithbsmiley/investigate.vim
"   * danchoi/ri.vim
"   * thinca/vim-ref
" * Investigate project-specific configuration
"   * Automatically source `~/projects/foo/{.exrc,.vimrc}`:
"     ```vim
"     set secure
"     set exrc
"     ```
" * Running unit tests
"   * See janko-m/vim-test for both Jasmine and RSpec
"   * Configure vim-dispatch to run Jasmine tests
"     * https://github.com/tpope/vim-dispatch/issues/30
"   * Configure vim-dispatch to run RSpec tests
"     * https://github.com/tpope/vim-dispatch/issues/30
"     * thoughtbot/vim-rspec
" * Investigate smartindent and cinwords
" * Show extra whitespace
"   * guiniol/vim-showspaces
" ## Plugins to Consider
" ### For editing large files
" * LargeFile (#1506) - disables features for increased performance
" ### For Global Search/Replace
" * skwp/greplace.vim
" * gabesoft/vim-ags
" ### For Git/GitHub
" * idanarye/vim-merginal - addon for fugitive for handling merging branches and rebasing
" * jaxbot/github-issues.vim - interfaces for GitHub issues API
" * codegram/vim-codereview - manage GitHub pull requests
" * tpope/vim-rhubarb - autocomplete GitHub issue numbers
" * int3/vim-extradite - browsing git history
" ### For Project File Navigation and Tooling
" * tpope/vim-projectionist
" * malkomalko/projections.vim - goto related files (e.g. test and implementation)
" * tpope/vim-rails
" * tpope/vim-dotenv - per project settings based on .env and Procfile
" ### For Code Analysis
" * marijnh/tern_for_vim - JavaScript
" * Chiel92/vim-autoformat - use external programs, better than indent ftplugin?
" * calebsmith/vim-lambdify - conceal function keyword
" * koalaman/spellcheck - linting for shell scripts
" * rsense/rsense - Ruby
" ### For Code Refactoring
" * jbgutierrez/vim-partial - for extracting template partials
" * pelodelfuego/vim-swoop - search replace with context
" * ecomba/vim-ruby-refactoring
" * AndrewRadev/switch.vim - pattern-based toggling
" * mvolkmann/vim-js-arrow-function - convert between function and arrow
" ### For Brackets and Delimited/Structured Text
" * amirh/HTML-AutoCloseTag
" * wellle/targets.vim - enhances ([' text objects and adds separator text objects
" * guns/vim-sexp
" * tpope/vim-sexp-mappings-for-regular-people
" * terryma/vim-expand-region - press v multiple times to select bigger region
" * tpope/vim-jdaddy - text objects for JSON
" ### For External Tools
" * benmills/vimux - tmux
" * tpope/vim-tbone - tmux paste buffer
" * yssl/VIntSearch - search using ctags and grep
" ### For Adding New Motions
" * justinmk/vim-sneak - 2 character searching
" ### For Visualizing Metadata
" jeetsukumaran/vim-markology - visualize marks
" ### For Debugging
" * mattboehm/vim-unstack - navigate stack traces
" ### For automatically running code
" * jaxbot/browserlink.vim
" ### For interacting with ctags
" * majutsushi/tagbar
" ### For specific languages
" * tpope/vim-sleuth - automatically set indentation settings
" ### For quickly inserting text
" * Wolfy87/vim-expand
" ### For Haskell
" * begriffs/haskell-vim-now
" ### For executing code from a buffer
" * diepm/vim-rest-console
" * jpalardy/vim-slime

call plug#begin()
Plug 'junegunn/vim-plug', {'do': 'ln -sf $(realpath plug.vim) ~/.vim/autoload'}
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'

Plug 'tpope/vim-sensible'
Plug 'rstacruz/vim-opinion'
call plug#load('vim-sensible', 'vim-opinion')

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
nnoremap <Leader>f :Unite -no-split -hide-source-names -start-insert file_rec/async file/new<CR>
nnoremap <Leader>l :Unite -no-split -hide-source-names -start-insert script:/bin/bash:/home/vinsonchuong/projects/unite-scripts/licenses<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :Gstatus<CR>
nnoremap <Leader>m :Make<CR>

let g:lightline = {'colorscheme': 'solarized_light'}

let g:unite_source_rec_async_command='ag --follow --nocolor --nogroup --hidden -g "" --ignore .git'
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
