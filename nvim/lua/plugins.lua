return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -- utilities
    use 'nvim-tree/nvim-web-devicons'
    use 'windwp/nvim-autopairs'
    use 'luochen1990/rainbow'
    use 'tpope/vim-commentary'

    -- makefiles
    use 'tpope/vim-dispatch'

    -- fuzzy finding
    use 'nvim-telescope/telescope.nvim'

    -- debug
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-cmdline'},
        {'L3MON4D3/LuaSnip'},
      }
    }
    use 'ray-x/lsp_signature.nvim'

    -- highlighting
    use 'Shirk/vim-gas'
    use 'RRethy/vim-illuminate'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
end)
