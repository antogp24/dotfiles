
-- Plugins
-- -------------------------------------------------------------

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Colorscheme theme
    use 'cocopon/iceberg.vim'

    -- Dependency for other plugins
    use "nvim-lua/plenary.nvim"

    -- Github
    use "tpope/vim-fugitive"

    -- Fuzzy finder
    use "nvim-telescope/telescope.nvim"

    -- autopairs () [] {} "" ''
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- Toggle Comments
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }

    -- syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Lsp
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- Installation
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
}
end)

-- Lua:
vim.o.background = 'dark'
vim.cmd("colorscheme iceberg")

-- Remappings
-- -------------------------------------------------------------

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>t", vim.cmd.Ex)

-- Fixing vanilla commands for more accepable behaviour
vim.keymap.set("n", "J", "<nop>")
vim.keymap.set("n", "<A-J>", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({"n", "v", "c", "i"}, "<C-c>", "<Esc>")
vim.keymap.set({"n", "v", "c", "i"}, "<C-g>", "<Esc>")

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("grep: ") })
end)

-- 4coder bindings 
vim.keymap.set('n', '<A-i>', builtin.buffers, {})
vim.keymap.set('n', '<A-o>', builtin.find_files, {})
vim.keymap.set("n", "<A-,>", "<C-w><C-w>")
vim.keymap.set("n", "<A-0>", "<C-w>c")
vim.keymap.set("n", "<A-1>", "<C-w>o")
vim.keymap.set("n", "<A-2>", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<A-3>", "<cmd>split<CR>")
vim.keymap.set("n", "<A-r>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Copy and pasting to clipboard
vim.keymap.set({ "n", "v" }, "<A-y>", [["+y]])
vim.keymap.set({ "n", "v" }, "<A-Y>", [["+Y]])
vim.keymap.set({ "n", "v" }, "<A-p>", [["+p]])
vim.keymap.set({ "n", "v" }, "<A-P>", [["+P]])

-- Paste and delete to void register
vim.keymap.set("x", "<leader>P", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Jumping
vim.keymap.set("n", "<leader><C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader><C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Misc
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { silent = true })

-- Relative line numbers in netrw
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

-- Git
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Sets
-- -------------------------------------------------------------

-- vim.opt.guicursor = ""

vim.api.nvim_exec([[
function! g:DisableMatchParen()
    if exists(":NoMatchParen")
        :NoMatchParen
    endif
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call DisableMatchParen()
augroup END
]], false)

vim.opt.nu = true
vim.opt.relativenumber = true

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

-- Treesitter
-- -------------------------------------------------------------

if vim.fn.has('win32') then
    -- Fix the lua.so not valid Win32 application
    require('nvim-treesitter.install').compilers = { "clang" }
end

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "vimdoc", "c", "odin", "python" },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Lsp

local lsp_zero = require("lsp-zero")
vim.g.lsp_zero_extend_lspconfig = 1

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
    },
    handlers = { lsp_zero.default_setup },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.confirm({select = true}),
        ['<C-n>'] = cmp_action.luasnip_jump_forward(),
        ['<C-p>'] = cmp_action.luasnip_jump_backward(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    })
})

lsp_zero.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp_zero.on_attach(function(client, bufnr)
    _ = client
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('lspconfig').ols.setup({})

lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = { globals = {'vim'}, },
    },
  },
}
lsp_zero.setup()
