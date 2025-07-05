local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
-- 
-- 2. 将 lazypath 设置为运行时路径
-- rtp（runtime path）
-- nvim进行路径搜索的时候，除已有的路径，还会从prepend的路径中查找
-- 否则，下面 require("lazy") 是找不到的
vim.opt.rtp:prepend(lazypath)
-- 安装插件管理器 lazy.nvim
require("lazy").setup({


    -- 侧边滚动
    'dstein64/nvim-scrollview',
    -- bufferline
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    -- 消息通知noice
    {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    }
},

  -- 提示窗口引擎插件
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
    -- 提供用于显示诊断等信息的列表
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
   },
    },
    -- 代码块缩进显示插件
{
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup {
        exclude = {
            filetypes = {
                "dashboard",
            },
        },
    }
  end,
},




    -- 给成对括号、花括号等添加不同的颜色 会造成一些卡顿
    {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    -- 一个超快的显示hex颜色的插件
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
    -- 在文件顶部显示目前函数名
  { 'nvim-treesitter/nvim-treesitter-context' },
    -- Vscode LSP图标
    { "onsails/lspkind-nvim" },

    -- 高亮TODO和FIX等注释
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
},

  -- 语法高亮（Treesitter）
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- DASHBOARD
  'nvimdev/dashboard-nvim',
  -- CompetiTest
{
	'xeluxee/competitest.nvim',
	dependencies = 'MunifTanjim/nui.nvim',
},
-- TokyoNight主题
'folke/tokyonight.nvim',
  -- LSP 设置
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- LSP 服务器自动安装器
      { "williamboman/mason.nvim", build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim" },
      -- 补全插件
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
    },
    config = function()
      require("mason").setup()

      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- clangd 配置
      lspconfig.clangd.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        flags = {
          debounce_text_changes = 150,
        },
      })
    end,
  },

  -- 补全插件配置
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 回车确认选择
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      sources = {
        { name = "nvim_lsp", max_item_count = 10 }, -- 设置 LSP 最多显示 10 条
        { name = "luasnip", max_item_count = 10 },   -- 设置 luasnip 最多显示 10 条
      },
      })
    end,
  },

  -- 模板片段支持
  {
    "L3MON4D3/LuaSnip",
    version = "^2.0.0",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- LSP 支持 + 安装器 + C++ clangd
  {
    "williamboman/mason.nvim",
    build = function()
      require("mason.api.command").MasonUpdate()
    end,
    config = function()
      require("mason").setup()
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  -- lualine
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
},
-- autopair
    {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
    },
  -- 实时变量高亮（同名变量）
  {
    "RRethy/vim-illuminate",
    config = function()
      require('illuminate').configure({
        delay = 200,
        large_file_cutoff = 2000,
        filetypes_denylist = { "NvimTree", "neo-tree", "TelescopePrompt" },
      })
    end,
  },

  -- 文件树
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },
  { "nvim-tree/nvim-web-devicons" },

  -- 输入法自动切换插件
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({
        default_im_select = "com.apple.keylayout.ABC",
      })
    end,
  },
-- Wakatime
{ 'wakatime/vim-wakatime', lazy = false },
  -- GDB 调试插件
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
dap.adapters.gdb = {
  id = 'gdb',
  type = 'executable',
  command = 'gdb', -- 确保 gdb 已安装并可用
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
  },
}    end
  },

})

vim.api.nvim_set_keymap('i', '<A-j>', '<Down>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-k>', '<Up>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', {noremap = true, silent = true})

-- 基本设置
vim.opt.number = true
vim.opt.relativenumber = true

require('lualine').setup()

-- Treesitter 配置
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "c", "lua" },
  highlight = { enable = true },
}

-- Mason & LSP 配置
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
})
require("lspconfig").clangd.setup({})

-- illuminate 配置
require('illuminate').configure()

-- 文件树快捷键
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- F5 编译并运行 C++
local cpp_terminal_winid = nil
vim.keymap.set("n", "<F5>", function()
  vim.cmd("w")
  local filename = vim.fn.expand("%")
  local outfile = vim.fn.expand("%:r")
  local cmd = string.format("g++ -std=c++17 -O2 -Wall %s -o %s && ./%s", filename, outfile, outfile)
  vim.cmd("split")
  vim.cmd("enew")
  cpp_terminal_winid = vim.api.nvim_get_current_win()
  vim.cmd("term " .. cmd)
end, { noremap = true, silent = true })

-- F6 关闭编译终端
vim.keymap.set("n", "<F6>", function()
  if cpp_terminal_winid and vim.api.nvim_win_is_valid(cpp_terminal_winid) then
    vim.api.nvim_win_close(cpp_terminal_winid, true)
    cpp_terminal_winid = nil
  else
    print("No terminal window to close.")
  end
end, { noremap = true, silent = true })

-- 搜索当前光标词
vim.keymap.set("n", "<C-f>", ":set hlsearch!<CR>/<C-r><C-w><CR>", { noremap = true, silent = true })

-- 替换当前词
vim.keymap.set("n", "<C-h>", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { noremap = true })

-- 系统剪贴板支持
if vim.fn.has('clipboard') == 1 then
  vim.opt.clipboard:append { 'unnamedplus' }
else
  vim.notify("Clipboard not supported. Install xclip/wl-clipboard.", vim.log.levels.WARN)
end

-- Visual 复制
vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })

-- Normal 模式复制整个文件
vim.keymap.set("n", "<C-S-c>", function()
  if vim.fn.has('clipboard') == 1 then
    vim.cmd('normal! gg"+yG')
    vim.notify("Copied to clipboard!", vim.log.levels.INFO)
  else
    vim.notify("Clipboard not available.", vim.log.levels.ERROR)
  end
end, { noremap = true, silent = true })

-- highlight 设置
vim.cmd [[
  hi IlluminatedWordText gui=none guibg=#3c3836
  hi IlluminatedWordRead gui=none guibg=#3c3836
  hi IlluminatedWordWrite gui=none guibg=#3c3836
]]

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.background = "dark"

-- 输入法自动切换（根据平台）
if vim.fn.has('mac') == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.fn.system("im-select com.apple.keylayout.ABC")
    end
  })
elseif vim.fn.has('unix') == 1 and vim.fn.has('mac') == 0 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.fn.system("fcitx5-remote -c")
    end
  })
elseif vim.fn.has('win32') == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.fn.system("im-select 1033")
    end
  })
end

-- ==========================
-- 中文 Vim 指令 & 快捷键 浮窗（F1 键 切换）
-- ==========================

local cheat_cn = [[
Vim 中文使用手册

...

本配置相关快捷键
- F2 打开/关闭文件树
- F5 编译运行 C++
- F6 关闭编译窗口
- Shift+F9 设置/取消断点（GDB）
- F8 单步执行 Step Over（GDB）
- Shift+F8 启动或继续运行调试（GDB）
- Ctrl+f 搜索当前光标词并切换高亮
- Ctrl+h 替换当前光标词
- Ctrl+Shift+C 复制选中文本
- Ctrl+Shift+C (Normal 模式) 复制整个文件
- :LspInfo 查看 LSP 状态
- gd 跳转到定义  gr 查找引用  K 查看文档
- Alt+h 左移 Alt+j 上移 Alt+k 下移 Alt+l 右移
]]

local help_win_id = nil
vim.keymap.set({'n','i','v','x','o'}, '<F1>', '<Nop>', { silent = true, noremap = true })

vim.keymap.set('n', '<F1>', function()
  if help_win_id and vim.api.nvim_win_is_valid(help_win_id) then
    vim.api.nvim_win_close(help_win_id, true)
    help_win_id = nil
    return
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(cheat_cn, '\n'))
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  local width  = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines   * 0.8)
  local row    = math.floor((vim.o.lines - height) / 2)
  local col    = math.floor((vim.o.columns - width)  / 2)
  local opts = {
    style    = 'minimal',
    relative = 'editor',
    width    = width,
    height   = height,
    row      = row,
    col      = col,
    border   = 'rounded',
  }
  help_win_id = vim.api.nvim_open_win(buf, true, opts)
  vim.keymap.set('n', '<Esc>', function()
    if help_win_id and vim.api.nvim_win_is_valid(help_win_id) then
      vim.api.nvim_win_close(help_win_id, true)
      help_win_id = nil
    end
  end, { buffer = buf, silent = true })
end, { noremap = true, silent = true })

-- GDB 快捷键绑定
local dap = require("dap")
vim.keymap.set("n", "<S-F9>", dap.toggle_breakpoint, { noremap = true, silent = true })
vim.keymap.set("n", "<F8>", dap.step_over, { noremap = true, silent = true })
vim.keymap.set("n", "<F20>", dap.continue, { noremap = true, silent = true })

-- DASHBOARD

local status, db  = pcall(require, "dashboard")
if not status then
  vim.notify("没有找到 dashboard")
  return
end

db.setup({
  theme = 'hyper',
  config = {
    week_header = {
    enable = true,
    },
    shortcut = {
      { desc = '󰊳 init.lua', 
        group = '@property', 
        action = 'edit ~/.config/nvim/init.lua', 
        key = 'e' 
      },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Projects',
        group = 'DiagnosticHint',
        action = 'Telescope projects',
        key = 'p',
      },
      {
        desc = ' Oldfiles',
        group = 'Number',
        action = 'Telescope oldfiles',
        key = 'o',
      },
    },
  },
})



-- CompetiTest

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
			open_when_compilation_fails = true,
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

-- Noice
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- TokyoNight
vim.cmd[[colorscheme tokyonight]]

--bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

-- 滚动

