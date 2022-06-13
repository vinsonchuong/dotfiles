let g:ale_disable_lsp=1

call plug#begin()
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'nvim-telescope/telescope.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

Plug 'tami5/lspsaga.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

Plug 'mbbill/undotree'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive' | Plug 'gregsexton/gitv'
Plug 'dense-analysis/ale'
Plug 'vinsonchuong/vim-stdtabs'
Plug 'sheerun/vim-polyglot'

Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'

Plug 'kana/vim-textobj-user'
Plug 'thinca/vim-textobj-between'
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-entire'
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
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim'
call plug#end()

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set background=light
colorscheme solarized
let g:lightline={'colorscheme': 'solarized'}
let mapleader="\<Space>"

set nowrap
set number
set numberwidth=5
set undofile
set backupcopy=yes
set diffopt+=vertical
set foldmethod=syntax
set completeopt=menu,menuone,noselect

lua <<EOF
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local luasnip = require('luasnip')
local saga = require('lspsaga')

require('nvim-treesitter.configs').setup({
  ensure_installed = {'html', 'css', 'javascript'},
  sync_install = false,
  highlight = {
    enable = true
  }
})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  experimental = {
    native_menu = false,
    ghost_text = true
  }
})

saga.init_lsp_saga({
  rename_action_keys = {
    quit = '<Esc>',
    exec = '<CR>',
  },
  use_saga_diagnostic_sign = false,
  code_action_prompt = {
    enable = false,
    sign = false,
  },
})

require('Comment').setup({
  mappings = {
    basic = true,
    extra = true,
  }
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  --- buf_set_keymap('n', '<Leader>ra', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end
EOF

let g:suda_smart_edit=1

" let g:test#strategy={
"   \ 'nearest': 'basic',
"   \ 'file': 'dispatch',
"   \ 'suite': 'dispatch'
" \ }
let g:test#javascript#ava#file_pattern='\v\.test\.js$'
let g:dispatch_compilers={
  \ 'ava': 'ava'
\ }

let g:ale_linters_explicit=1
let g:ale_fix_on_save=1
let g:ale_fixers={
  \ 'javascript': ['xo']
\ }
let g:ale_linters={
  \ 'javascript': ['xo']
\ }

nnoremap <silent> K :Lspsaga hover_doc<CR>
nnoremap gd <Cmd>Telescope lsp_definitions<CR>
nnoremap gr <Cmd>Telescope lsp_references<CR>
nnoremap gs <Cmd>Telescope lsp_document_symbols<CR>
nnoremap gS <Cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <silent><Leader>ra :Lspsaga code_action<CR>
nnoremap <silent><Leader>rr :Lspsaga rename<CR>
" nnoremap <Leader>e <Cmd>Telescope lsp_document_diagnostics<CR>
nnoremap <silent> <Leader>e :Lspsaga show_line_diagnostics<CR>
nnoremap <Leader>E <Cmd>Telescope lsp_workspace_diagnostics<CR>
nnoremap <Leader>f <Cmd>Telescope find_files hidden=true<CR>
nnoremap <Leader>S <Cmd>Telescope live_grep<CR>
nnoremap <Leader>s <Cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
nnoremap <Leader>g :0Git<CR>
nnoremap <Leader>t :TestNearest<CR>
nnoremap <Leader>T :TestFile<CR>
