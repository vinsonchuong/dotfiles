-- luacheck: globals vim

require("packer").startup(function(use)
	use("williamboman/mason.nvim")
	use("WhoIsSethDaniel/mason-tool-installer.nvim")
	use("jayp0521/mason-null-ls.nvim")

	use("neovim/nvim-lspconfig")
	use("folke/neodev.nvim")

	use("nvim-lua/plenary.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope.nvim")
	use("jose-elias-alvarez/null-ls.nvim")

	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/nvim-cmp")
	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")

	use("nvim-tree/nvim-web-devicons")

	use("kkharji/lspsaga.nvim")

	use("folke/trouble.nvim")

	use("tpope/vim-fugitive")
	use("gregsexton/gitv")

	use("sindrets/diffview.nvim")

	use("zbirenbaum/copilot.lua")

	use("numToStr/Comment.nvim")

	use("Tsuzat/NeoSolarized.nvim")
	use("itchyny/lightline.vim")

	use("mbbill/undotree")
	use("tpope/vim-vinegar")
	use("vinsonchuong/vim-stdtabs")
	use("sheerun/vim-polyglot")

	use("vim-test/vim-test")
	use("tpope/vim-dispatch")

	use("kana/vim-textobj-user")
	use("thinca/vim-textobj-between")
	use("glts/vim-textobj-comment")
	use({ "kana/vim-textobj-entire", after = "kana/vim-textobj-user" })
	use({ "kana/vim-textobj-fold", after = "kana/vim-textobj-user" })
	use({ "kana/vim-textobj-indent", after = "kana/vim-textobj-user" })
	use({ "kana/vim-textobj-lastpat", after = "kana/vim-textobj-user" })
	use({ "kana/vim-textobj-line", after = "kana/vim-textobj-user" })
	use("sgur/vim-textobj-parameter")
	use("saaguero/vim-textobj-pastedtext")
	use({ "kana/vim-textobj-syntax", after = "kana/vim-textobj-user" })
	use("whatyouhide/vim-textobj-xmlattr")

	use("AndrewRadev/splitjoin.vim")
	use("bronson/vim-visual-star-search")
	use("jiangmiao/auto-pairs")
	use("mhinz/vim-grepper")
	use("tpope/vim-repeat")
	use("tpope/vim-abolish")
	use("tpope/vim-characterize")
	use("tpope/vim-endwise")
	use("tpope/vim-eunuch")
	use("tpope/vim-surround")
	use("tpope/vim-speeddating")
	use("tpope/vim-unimpaired")
	use("lambdalisue/suda.vim")
end)

require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua-language-server",
		"bash-language-server",
		"typescript-language-server",
		"json-lsp",
	},
	auto_update = true,
})

require("copilot").setup({
	filetypes = {
		text = false,
	},
	copilot_node_command = vim.fn.expand("$HOME") .. "/opt/n/n/versions/node/16.18.1/bin/node",
})

local colors = require("NeoSolarized.colors").setup()
require("NeoSolarized").setup()
vim.api.nvim_command("colorscheme NeoSolarized")
vim.opt.background = "light"

vim.api.nvim_command("highlight Normal guifg=" .. colors.fg2)
vim.api.nvim_command("highlight NormalNC guifg=" .. colors.fg2)
vim.api.nvim_command("highlight NormalSB guifg=" .. colors.fg2)
vim.api.nvim_command("highlight WinSeparator guifg=" .. colors.bg1)

vim.g.lightline = { colorscheme = "solarized" }

vim.g.mapleader = " "

vim.opt.wrap = false
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.undofile = true
vim.opt.backupcopy = "yes"
vim.opt.diffopt:append({ "vertical" })
vim.opt.foldmethod = "syntax"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

local nvim_lsp = require("lspconfig")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")

require("nvim-treesitter.configs").setup({
	ensure_installed = { "html", "css", "javascript" },
	sync_install = false,
	highlight = {
		enable = true,
	},
})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
	experimental = {
		native_menu = false,
		ghost_text = true,
	},
})

require("lspsaga").init_lsp_saga({
	rename_action_keys = {
		quit = "<Esc>",
		exec = "<CR>",
	},
	use_saga_diagnostic_sign = false,
	code_action_prompt = {
		enable = false,
		sign = false,
	},
})

require("trouble").setup()

require("Comment").setup({
	mappings = {
		basic = true,
		extra = true,
	},
})

require("telescope").setup({
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
		},
	},
})

require("neodev").setup()

local on_attach = function(client, bufnr) -- luacheck: ignore
	-- local function buf_set_keymap(...)
	-- 	vim.api.nvim_buf_set_keymap(bufnr, ...)
	-- end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- local opts = { noremap = true, silent = true }
	--- buf_set_keymap('n', '<Leader>ra', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local servers = { "sumneko_lua", "tsserver" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = cmp_nvim_lsp.default_capabilities(),
	})
end

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("NullLsFormatting", {})
null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
	sources = {
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.xo.with({
			command = "xo_d",
		}),
		null_ls.builtins.formatting.eslint_d.with({
			command = "xo_d",
			args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
		}),
	},
})

require("mason-null-ls").setup({
	ensure_installed = {
		"luacheck",
		"stylua",
	},
})

vim.g.suda_smart_edit = true

vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", { silent = true })
vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
vim.keymap.set("n", "gs", "<Cmd>Telescope lsp_document_symbols<CR>")
vim.keymap.set("n", "gS", "<Cmd>Telescope lsp_workspace_symbols<CR>")
vim.keymap.set("n", "<Leader>r", ":Lspsaga code_action<CR>")
vim.keymap.set("n", "<Leader>e", ":Lspsaga show_line_diagnostics<CR>", { silent = true })
vim.keymap.set("n", "<Leader>E", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
vim.keymap.set("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<Leader>S", "<Cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>s", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>")
vim.keymap.set("n", "<Leader>g", ":0Git<CR>")
vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>")
vim.keymap.set("n", "<Leader>T", ":TestFile<CR>")
