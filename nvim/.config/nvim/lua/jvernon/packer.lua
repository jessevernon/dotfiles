vim.cmd.packadd('packer.nvim')

return require("packer").startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                                                        , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        'catppuccin/nvim',
        as = 'catppuccin',
        config = function()
            vim.cmd('colorscheme catppuccin-latte')
        end
    })

    use({
            "folke/trouble.nvim",
            config = function()
                    require("trouble").setup {
                            icons = false,
                            -- your configuration comes here
                            -- or leave it empty to use the default settings
                            -- refer to the configuration section below
                    }
            end
    })


    use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
    use("nvim-treesitter/playground")
    use("theprimeagen/harpoon")
    use("theprimeagen/refactoring.nvim")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use("idanarye/vim-merginal")
    --use("nvim-treesitter/nvim-treesitter-context");

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use("folke/zen-mode.nvim")
    use("github/copilot.vim")
    use("tpope/vim-abolish")
    use("elihunter173/dirbuf.nvim")
    use("stefandtw/quickfix-reflector.vim")
    use("tpope/vim-rsi")
    use {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function ()
        require"octo".setup()
      end
    }
    use({
      "jackMort/ChatGPT.nvim",
        config = function()
          require("chatgpt").setup()
        end,
        requires = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim"
        }
    })
    use("dylon/vim-antlr")
    use("tpope/vim-dadbod")
end)
