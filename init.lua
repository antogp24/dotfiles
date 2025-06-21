-- Open my personal folder

local function cd_to_project_folder()
  local year = os.date("%Y")
  if vim.fn.has("win32") == 1 then
        vim.cmd("cd W:\\" .. year)
  else
    vim.cmd("cd ~/dev/" .. year)
  end
end
vim.api.nvim_create_user_command("Projects", cd_to_project_folder, {})

-- [[ Font and Font size in gui ]]
-- ---------------------------------------------------------------------------------------- --

vim.g.my_gui_font_face = "FiraCode NFM"
vim.g.my_gui_font_size = 11

local function clamp(x, min, max)
    if x < min then
        return min
    end
    if x > max then
        return max
    end
    return x
end

local function set_my_gui_font()
    vim.opt.guifont = string.format("%s:h%d", vim.g.my_gui_font_face, vim.g.my_gui_font_size)
end

local function resize_my_gui_font(increment)
    vim.g.my_gui_font_size = clamp(vim.g.my_gui_font_size + increment, 8, 24)
    set_my_gui_font()
end

set_my_gui_font()

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_cursor_trail_size = 0.0
    vim.g.neovide_cursor_animate_in_insert_mode = false

    vim.keymap.set("n", "<C-=>", function()
        resize_my_gui_font(1)
    end, { desc = "Increase font size by 1." })

    vim.keymap.set("n", "<C-->", function()
        resize_my_gui_font(-1)
    end, { desc = "Decrease font size by 1." })
end

-- [[ Setting options ]]
-- See :h vim.opt
-- See :h option-list
-- ---------------------------------------------------------------------------------------- --

-- Set <space> as the leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Flag to enable or disable using icons.
vim.g.have_nerd_font = true

-- Indentation configuration
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.opt.breakindent = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.mouse = "a"

-- Backup files configuration
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false

-- Searching configuration.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Decrease update time
vim.opt.updatetime = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Showing whitespace.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions whilst typing.
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- See :help confirm
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
-- ---------------------------------------------------------------------------------------- --

-- Make Control+Backspace have the same behavior as most text editors.
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })

-- Make Control+C  have the same behavior as Esc.
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Make duplicating lines have better cursor positioning.
vim.keymap.set("n", "<C-;>", "yymmp`mj", { noremap = true, silent = true, desc = "Duplicate a line" })

-- Managing copy pasting with the OS clipboard
vim.keymap.set("n", "<leader>P", [["+p]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Clear highlights when switching to normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<C-;>", "<C-\\><C-n>", { desc = "Duplicate a line" })

-- [[ Basic Autocommands ]]
--  See :h lua-guide-autocommands
-- ---------------------------------------------------------------------------------------- --

--  See :h vim.highlight.on_yank()
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when copying text",
    group = vim.api.nvim_create_augroup("my-highlight-on-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Running Compilation Commands ]]
-- ---------------------------------------------------------------------------------------- --

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- ---------------------------------------------------------------------------------------- --

require("lazy").setup({
    -- Theme / Colorscheme
    {
        "oahlen/iceberg.nvim",
        config = function()
            vim.cmd("colorscheme iceberg")
        end,
    },
    {
        "antogp24/nvim-compile",
        config = function()
            local compile = require("nvim-compile")
            compile.setup()
            vim.keymap.set("n", "<A-S-m>", compile.compile, { desc = "Compile a command." })
            vim.keymap.set("n", "<A-m>", compile.compile_last, { desc = "Compile the last command." })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        keys = {
            { "<C-S-k>", mode = { "n", "x" } },
            { "<C-S-j>", mode = { "n", "x" } },
            { "<C-.>", mode = { "n", "x" } },
            { "<C-,>", mode = { "n", "x" } },
          },
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            -- Add or skip cursor above/below the main cursor.
            vim.keymap.set({ "n", "x" }, "<C-S-k>", function()
                mc.lineAddCursor(-1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-S-j>", function()
                mc.lineAddCursor(1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-k>", function()
                mc.lineSkipCursor(-1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-j>", function()
                mc.lineSkipCursor(1)
            end)

            -- Add or skip adding a new cursor by matching word/selection
            vim.keymap.set({ "n", "x" }, "<C-.>", function()
                mc.matchAddCursor(1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-S-.>", function()
                mc.matchSkipCursor(1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-,>", function()
                mc.matchAddCursor(-1)
            end)
            vim.keymap.set({ "n", "x" }, "<C-S-,>", function()
                mc.matchSkipCursor(-1)
            end)

            -- These mappings only apply when there are multiple cursors.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<C-p>", mc.prevCursor)
                layerSet({ "n", "x" }, "<C-n>", mc.nextCursor)

                layerSet("n", "<C-c>", mc.clearCursors)
                layerSet("n", "<esc>", mc.clearCursors)
            end)

            -- Customize how cursors look.
            vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
            vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
            vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
            vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
            vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { reverse = true })
            vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
    },

    { -- Fuzzy Finder
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("cmake") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            vim.keymap.set("n", "<leader>/", function()
                local theme = require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                })
                builtin.current_buffer_fuzzy_find(theme)
            end, { desc = "[/] Fuzzily search in current buffer" })

            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },

    -- LSP Plugins
    {
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            --  This function gets run when an LSP attaches to a buffer with a certain file type.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("my-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
                    map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
                    map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
                    map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
                end,
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({capabilities = capabilities})
                    end,
                },
            })
        end,
    },

    { -- Autocompletion
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "1.*",
        dependencies = {},
        opts = {
            -- See :h ins-completion
            keymap = {
                preset = "default",
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- See :h blink-cmp-config-completion
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },

            -- See :h blink-cmp-config-sources
            sources = {
                default = { "lsp", "path" },
                providers = {},
            },

            -- See :h blink-cmp-config-fuzzy
            fuzzy = { implementation = "lua" },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },
        },
    },

    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        },
    },

    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
}, {
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
