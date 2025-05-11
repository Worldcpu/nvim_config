local lspconfig = require("lspconfig")

-- clangd 配置（仅注册一次）
lspconfig.clangd.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities({
    position_encoding = "utf-8" -- 强制设置为 utf-8
  }),
  cmd = { "clangd", "--background-index", "--completion-style=detailed", "--suggest-missing-includes" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "CMakeLists.txt", ".git"),
})

-- 自动补全配置（保持不变）
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp", max_item_count = 5 },
    { name = "buffer",   max_item_count = 5 },
    { name = "path",     max_item_count = 5 },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
})
