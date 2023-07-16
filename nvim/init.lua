-- luacheck: globals vim

---@param name string
-- local function package(spec)
-- 	local packer_spec = {}
-- 	packer_spec.name = spec[1]
--
-- 	local org, repo = string.match(packer_spec.name, '^([^/]*)/([^/]*)$')
--
-- 	if spec.config == true then
-- 		local file = string.match(repo, '^([^.]*)%.nvim$')
-- 		packer_spec.config = function()
-- 			require(file).setup()
-- 		end
-- 	elseif typeof(spec.config) == 'table' then
-- 		local file = string.match(repo, '^([^.]*)%.nvim$')
-- 		packer_spec.config = function()
-- 			require(file).setup(spec.config)
-- 		end
-- 	end
--
-- 	return packer_spec
-- end

require("packer").startup({
	{
		{
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "lua", "vim", "bash", "html", "css", "javascript" },
					sync_install = false,
					auto_install = true,
					highlight = {
						enable = true,
					},
					indent = {
						enable = true,
					},
				})

				vim.opt.foldmethod = "expr"
				vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

				require("nvim-treesitter.install").update()
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			},
			config = function()
				require("telescope").setup({
					pickers = {
						find_files = {
							find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
						},
					},
				})
			end,
		},
		{
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		},
		{
			"Tsuzat/NeoSolarized.nvim",
			config = function()
				require("NeoSolarized").setup({
					style = "light",
					on_highlights = function(highlights, colors)
						highlights.Normal.fg = colors.fg2
						highlights.NormalNC.fg = colors.fg2
						highlights.NormalSB.fg = colors.fg2
						highlights.WinSeparator.fg = colors.bg1
					end,
				})
				vim.cmd("colorscheme NeoSolarized")
				vim.opt.background = "light"
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			after = { "NeoSolarized.nvim" },
			config = function()
				require("lualine").setup({
					options = {
						theme = "NeoSolarized",
						icons_enabled = false,
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
					},
				})
			end,
		},
		{ "vinsonchuong/vim-stdtabs" },
		{ "sheerun/vim-polyglot" },
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			after = { "mason.nvim" },
			config = function()
				require("mason-tool-installer").setup({
					ensure_installed = {
						"lua-language-server",
						"bash-language-server",
						"typescript-language-server",
						"marksman",
						"json-lsp",
						"luacheck",
						"stylua",
						"fixjson",
					},
					auto_update = true,
				})
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			requires = { "neovim/nvim-lspconfig" },
			after = { "mason.nvim" },
			event = "User MasonToolsUpdateCompleted",
			config = function()
				local plugin = require("mason-lspconfig")
				plugin.setup()
				plugin.setup_handlers({
					function(name)
						require("lspconfig")[name].setup({})
					end,
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							settings = {
								Lua = {
									workspace = {
										checkThirdParty = false,
									},
								},
							},
						})
					end,
					["tsserver"] = function()
						require("lspconfig").tsserver.setup({
							on_attach = function(client)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
							end,
						})
					end,
				})
			end,
		},
		{
			"jayp0521/mason-null-ls.nvim",
			requires = { "jose-elias-alvarez/null-ls.nvim" },
			after = { "mason.nvim", "null-ls.nvim" },
			event = "User MasonToolsUpdateCompleted",
			config = function()
				local plugin = require("mason-null-ls")
				plugin.setup()
			end,
		},
		{
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				local plugin = require("null-ls")
				local augroup = vim.api.nvim_create_augroup("NullLsFormatting", {})
				plugin.setup({
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
						plugin.builtins.diagnostics.xo.with({
							command = "xo_d",
						}),
						plugin.builtins.formatting.eslint_d.with({
							command = "xo_d",
							args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
						}),
					},
				})
			end,
		},
		{
			"folke/neodev.nvim",
			requires = { "neovim/nvim-lspconfig" },
			after = { "mason-lspconfig.nvim" },
			config = function()
				require("neodev").setup()
			end,
		},
		{
			"hrsh7th/cmp-nvim-lsp",
			requires = { "hrsh7th/nvim-cmp" },
		},
		{
			"saadparwaiz1/cmp_luasnip",
			requires = { "hrsh7th/nvim-cmp" },
		},
		{ "L3MON4D3/LuaSnip" },
		{
			"hrsh7th/nvim-cmp",
			after = { "nvim-lspconfig", "LuaSnip" },
			config = function()
				local plugin = require("cmp")
				plugin.setup({
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					mapping = {
						["<C-p>"] = plugin.mapping.select_prev_item(),
						["<C-n>"] = plugin.mapping.select_next_item(),
						["<C-e>"] = plugin.mapping.abort(),
						["<C-y>"] = plugin.mapping.confirm({
							behavior = plugin.ConfirmBehavior.Replace,
							select = true,
						}),
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
			end,
		},
		{
			"folke/trouble.nvim",
			config = function()
				require("trouble").setup()
			end,
		},

		{ "tpope/vim-fugitive" },
		{ "gregsexton/gitv" },

		{ "sindrets/diffview.nvim" },

		{
			"zbirenbaum/copilot.lua",
			config = function()
				require("copilot").setup({
					filetypes = {
						text = false,
					},
					copilot_node_command = vim.fn.expand("$HOME") .. "/opt/n/n/versions/node/16.18.1/bin/node",
				})
			end,
		},

		{ "mbbill/undotree" },
		{ "tpope/vim-vinegar" },

		{
			"vim-test/vim-test",
			config = function()
				vim.g["test#javascript#ava#file_pattern"] = "test\\.js$"
			end,
		},

		{ "thinca/vim-textobj-between" },
		{ "glts/vim-textobj-comment" },
		{ "kana/vim-textobj-entire",        requires = "kana/vim-textobj-user" },
		{ "kana/vim-textobj-fold",          requires = "kana/vim-textobj-user" },
		{ "kana/vim-textobj-indent",        requires = "kana/vim-textobj-user" },
		{ "kana/vim-textobj-lastpat",       requires = "kana/vim-textobj-user" },
		{ "kana/vim-textobj-line",          requires = "kana/vim-textobj-user" },
		{ "saaguero/vim-textobj-pastedtext" },
		{ "whatyouhide/vim-textobj-xmlattr" },

		{ "AndrewRadev/splitjoin.vim" },
		{ "bronson/vim-visual-star-search" },
		{ "jiangmiao/auto-pairs" },
		{ "mhinz/vim-grepper" },
		{ "tpope/vim-repeat" },
		{ "tpope/vim-abolish" },
		{ "tpope/vim-characterize" },
		{ "tpope/vim-endwise" },
		{ "tpope/vim-eunuch" },
		{ "tpope/vim-surround" },
		{ "tpope/vim-speeddating" },
		{ "tpope/vim-unimpaired" },
		{ "lambdalisue/suda.vim" },
	},
})

vim.g.mapleader = " "

vim.opt.wrap = false
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.undofile = true
vim.opt.backupcopy = "yes"
vim.opt.diffopt:append({ "vertical" })
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.g.suda_smart_edit = true

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers["textDocument/hover"], {
	border = "single",
	width = 60,
})
vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers["textDocument/codeAction"], {
	border = "single",
	width = 60,
})

vim.diagnostic.config({
	float = {
		border = "single",
	},
})

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
vim.keymap.set("n", "gs", "<Cmd>Telescope lsp_document_symbols<CR>")
vim.keymap.set("n", "gS", "<Cmd>Telescope lsp_workspace_symbols<CR>")

vim.keymap.set("n", "<Leader>r", vim.lsp.buf.code_action)
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)

vim.keymap.set("n", "<Leader>E", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
vim.keymap.set("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<Leader>S", "<Cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>s", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>")
vim.keymap.set("n", "<Leader>g", ":0Git<CR>")
vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>")
vim.keymap.set("n", "<Leader>T", ":TestFile<CR>")
