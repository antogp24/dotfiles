require('plugins')
require('set')
require('remap')
require('c_binds')
require('mylsp')

-- colorscheme
vim.cmd('colorscheme habamax')

-- statusline
require('phyline')

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require('nvim-autopairs').setup {}

-- nvim-dap
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode',
  name = 'lldb'
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.cpp = dap.configurations.c

