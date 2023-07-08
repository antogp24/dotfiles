local lsp = require('lsp-zero')

lsp.preset("recommended")

lsp.ensure_installed({
    'clangd',
})

lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { buffer = bufnr, noremap=true, silent=true }
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', 's', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('i', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.keymap.set('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.keymap.set('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', ',D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', ',qf', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.keymap.set('n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lsp.on_attach(on_attach)
lsp.setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

require('lspconfig').clangd.setup{
  on_attach = on_attach,
  cmd = {
    "/usr/bin/clangd",
    "--background-index",
    "--pch-storage=memory",
    "--all-scopes-completion",
    "--pretty",
    "--header-insertion=never",
    "-j=4",
    "--inlay-hints",
    "--header-insertion-decorators",
    "--function-arg-placeholders",
    "--completion-style=detailed"
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
  root_dir = require('lspconfig').util.root_pattern("src"),
  init_option = { fallbackFlags = {  "-std=c99"  } },
  capabilities = capabilities
}

local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require "lsp_signature".setup({
  hint_prefix = "",
  floating_window = false,
  bind = true,
})

