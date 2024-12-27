-- Plugins
-- -------------------------------------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call("plug#begin")
Plug('nvim-lua/plenary.nvim')
Plug('stevearc/oil.nvim')
Plug('lewis6991/gitsigns.nvim')
Plug('nvim-telescope/telescope-fzf-native.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('antogp24/dumb-project-nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('navarasu/onedark.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('p00f/nvim-ts-rainbow')
Plug('nvim-treesitter/nvim-treesitter')
Plug('numToStr/Comment.nvim')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')
Plug('Saghen/blink.cmp')
vim.call("plug#end")

-- Theme
-- -------------------------------------------------------------------------------------
require('onedark').setup({
    code_style = {
        comments = 'none',
    },
})
vim.cmd('silent! colorscheme onedark')

-- Options
-- -------------------------------------------------------------------------------------
vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.mouse = "a"

-- Nice Default Bindings
-- -------------------------------------------------------------------------------------
-- Overriding default behaivior of some bindings.
vim.api.nvim_set_keymap('i', '<C-C>', '<esc>', { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Moving between panes and splitting them.
vim.keymap.set("n", "<A-,>", "<C-w><C-w>")
vim.keymap.set("n", "<A-0>", "<C-w>c")
vim.keymap.set("n", "<A-1>", "<C-w>o")
vim.keymap.set("n", "<A-2>", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<A-3>", "<cmd>split<CR>")

-- Copy/Paste with clipboard.
vim.keymap.set({ "n", "v" }, "<A-y>", [["+y]])
vim.keymap.set({ "n", "v" }, "<A-Y>", [["+Y]])
vim.keymap.set({ "n", "v" }, "<A-p>", [["+p]])
vim.keymap.set({ "n", "v" }, "<A-P>", [["+P]])

-- Paste and delete to void register
vim.keymap.set("x", "<leader>P", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Autocommands.
-- -------------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Treesitter
-- -------------------------------------------------------------------------------------
require("nvim-treesitter").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
})

require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "markdown", "asm", "c", "odin", "glsl", "hlsl" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = false,
        extended_mode = true,
    }
})

-- gitsigns.nvim: Git modification signs on the left of buffers.
-- -------------------------------------------------------------------------------------
require('gitsigns').setup()

-- Comment.nvim: Toggling comments on any programming language.
-- -------------------------------------------------------------------------------------
require('Comment').setup()
vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current)

-- lualine.nvim: Nice statusline.
-- -------------------------------------------------------------------------------------
require('lualine').setup()

-- oil.nvim: File explorer with intuitive buffer editing.
-- -------------------------------------------------------------------------------------
require('oil').setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- dumb-project-nvim: My plugin for managing projects.
-- -------------------------------------------------------------------------------------
require('dumb-project').setup({
    file_explorer_command = "Oil",
})
vim.keymap.set('n', '<C-L>', require('dumb-project').all_plugin_commands)

-- telescope.nvim: Fuzzy finder for files and buffers.
-- -------------------------------------------------------------------------------------
require('telescope').setup({
    pickers = {
        find_files = {
            theme = "ivy",
        },
        live_grep = {
            theme = "ivy",
        },
        buffers = {
            theme = "ivy",
        },
        help_tags = {
            theme = "ivy",
        },
    },
})
vim.keymap.set('n', '<M-o>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<M-i>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<M-s>', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)

-- mason.nvim: Installer of LSP servers, DAP servers, linters, and formatters.
-- -------------------------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "ols", "glsl_analyzer" },
})

-- blink.cmp: LSP Auto-Completion.
-- -------------------------------------------------------------------------------------
require('blink.cmp').setup({
    keymap = { preset = 'default' },
    fuzzy = {
        prebuilt_binaries = {
            download = true,
            force_version = "v0.8.2",
        },
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
})

-- nvim-lspconfig: Actually loads the installed LSP servers, etc.
-- -------------------------------------------------------------------------------------
local capabilities = require('blink.cmp').get_lsp_capabilities()

require'lspconfig'.lua_ls.setup{
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
            },
        },
    },
}

require'lspconfig'.ols.setup{
    capabilities = capabilities,
}

require'lspconfig'.glsl_analyzer.setup{
    capabilities = capabilities,
}
