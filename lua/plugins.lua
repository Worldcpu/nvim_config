local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
"nvim-neotest/nvim-nio",
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
},
      "hiphish/rainbow-delimiters.nvim",
    { 'wakatime/vim-wakatime', lazy = false },
{
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads first
},
{
	'xeluxee/competitest.nvim',
	dependencies = 'MunifTanjim/nui.nvim',
	config = function() require('competitest').setup() end,
},
"gen740/SmoothCursor.nvim",
"nvim-tree/nvim-tree.lua",
"nvim-lualine/lualine.nvim",
	  -- LSP 相关插
      "onsails/lspkind.nvim",
  "neovim/nvim-lspconfig",      -- LSP 配置
  "williamboman/mason.nvim",    -- LSP 安装管理器
  "williamboman/mason-lspconfig.nvim", -- Mason 的 LSP 配置
  "hrsh7th/nvim-cmp",           -- 自动补全引擎
  "hrsh7th/cmp-nvim-lsp",       -- LSP 补全源
  "hrsh7th/cmp-buffer",         -- 缓冲区补全
  "hrsh7th/cmp-path",           -- 路径补全
  "L3MON4D3/LuaSnip",           -- 代码片段引擎
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
},
    
})

require('competitest').setup {
	local_config_file_name = ".competitest.lua",

	floating_border = "rounded",
	floating_border_highlight = "FloatBorder",
	picker_ui = {
		width = 0.2,
		height = 0.3,
		mappings = {
			focus_next = { "j", "<down>", "<Tab>" },
			focus_prev = { "k", "<up>", "<S-Tab>" },
			close = { "<esc>", "<C-c>", "q", "Q" },
			submit = "<cr>",
		},
	},
	editor_ui = {
		popup_width = 0.4,
		popup_height = 0.6,
		show_nu = true,
		show_rnu = false,
		normal_mode_mappings = {
			switch_window = { "<C-h>", "<C-l>", "<C-i>" },
			save_and_close = "<C-s>",
			cancel = { "q", "Q" },
		},
		insert_mode_mappings = {
			switch_window = { "<C-h>", "<C-l>", "<C-i>" },
			save_and_close = "<C-s>",
			cancel = "<C-q>",
		},
	},
	runner_ui = {
		interface = "popup",
		selector_show_nu = false,
		selector_show_rnu = false,
		show_nu = true,
		show_rnu = false,
		mappings = {
			run_again = "R",
			run_all_again = "<C-r>",
			kill = "K",
			kill_all = "<C-k>",
			view_input = { "i", "I" },
			view_output = { "a", "A" },
			view_stdout = { "o", "O" },
			view_stderr = { "e", "E" },
			toggle_diff = { "d", "D" },
			close = { "q", "Q" },
		},
		viewer = {
			width = 0.5,
			height = 0.5,
			show_nu = true,
			show_rnu = false,
		},
	},
	popup_ui = {
		total_width = 0.8,
		total_height = 0.8,
		layout = {
			{ 4, "tc" },
			{ 5, { { 1, "so" }, { 1, "si" } } },
			{ 5, { { 1, "eo" }, { 1, "se" } } },
		},
	},
	split_ui = {
		position = "right",
		relative_to_editor = true,
		total_width = 0.3,
		vertical_layout = {
			{ 1, "tc" },
			{ 1, { { 1, "so" }, { 1, "eo" } } },
			{ 1, { { 1, "si" }, { 1, "se" } } },
		},
		total_height = 0.4,
		horizontal_layout = {
			{ 2, "tc" },
			{ 3, { { 1, "so" }, { 1, "si" } } },
			{ 3, { { 1, "eo" }, { 1, "se" } } },
		},
	},

	save_current_file = true,
	save_all_files = false,
	compile_directory = ".",
	compile_command = {
		c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
		cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
		rust = { exec = "rustc", args = { "$(FNAME)" } },
		java = { exec = "javac", args = { "$(FNAME)" } },
	},
	running_directory = ".",
	run_command = {
		c = { exec = "./$(FNOEXT)" },
		cpp = { exec = "./$(FNOEXT)" },
		rust = { exec = "./$(FNOEXT)" },
		python = { exec = "python", args = { "$(FNAME)" } },
		java = { exec = "java", args = { "$(FNOEXT)" } },
	},
	multiple_testing = -1,
	maximum_time = 5000,
	output_compare_method = "squish",
	view_output_diff = false,

	testcases_directory = "./testcases",
	testcases_use_single_file = true,
	testcases_auto_detect_storage = true,
	testcases_single_file_format = "$(FNOEXT).testcases",
	testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
	testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

	companion_port = 27121,
	receive_print_message = true,
	start_receiving_persistently_on_setup = true,
	template_file = false,
	evaluate_template_modifiers = false,
	date_format = "%c",
	received_files_extension = "cpp",
	received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
	received_problems_prompt_path = true,
	received_contests_directory = "$(CWD)",
	received_contests_problems_path = "$(PROBLEM).$(FEXT)",
	received_contests_prompt_directory = true,
	received_contests_prompt_extension = true,
	open_received_problems = true,
	open_received_contests = true,
	replace_received_testcases = false,
}

require("nvim-tree").setup()
vim.cmd("colorscheme onedark_dark")

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
