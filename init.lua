require('options')
require('plugins')
require('colorscheme')
require('lsp')
require('keymaps')
-- require("dap")

-- 显示诊断信息（错误、警告等）
vim.diagnostic.config({
  virtual_text = true,  -- 行内显示错误信息
  signs = true,         -- 行号旁显示标记
  underline = true,     -- 错误位置下划线
  update_in_insert = false, -- 不在插入模式更新（避免卡顿）
  severity_sort = true, -- 按严重性排序
})

vim.api.nvim_set_keymap('i', '<A-k>', '<Down>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-j>', '<Up>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', {noremap = true, silent = true})

