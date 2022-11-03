return require("packer").startup(function()
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("nvim-telescope/telescope.nvim")

    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    })

    -- LSP
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")
    use("tzachar/cmp-tabnine", { run = "./install.sh" })
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("glepnir/lspsaga.nvim")
    use("simrat39/symbols-outline.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    --use("zbirenbaum/copilot.lua")
    --use("zbirenbaum/copilot-cmp")
    use({
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()
            end, 100)
        end,
    })
    use({
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup {
                method = "getCompletionsCycling",
            }
            local cmp = require("cmp")
            if cmp.config ~= nil then
                cmp.setup({
                    sorting = {
                        priority_weight = 2,
                        comparators = {
                            require("copilot_cmp.comparators").prioritize,
                            require("copilot_cmp.comparators").score,

                            -- Below is the default comparitor list and order for nvim-cmp
                            cmp.config.compare.offset,
                            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                            cmp.config.compare.exact,
                            cmp.config.compare.score,
                            cmp.config.compare.recently_used,
                            cmp.config.compare.locality,
                            cmp.config.compare.kind,
                            cmp.config.compare.sort_text,
                            cmp.config.compare.length,
                            cmp.config.compare.order,
                        },
                    },
                })
            end
        end
    })

    -- Productivity
    use("sbdchd/neoformat")
    use("tpope/vim-fugitive")
    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")
    use("scrooloose/nerdcommenter")
    use("tpope/vim-abolish")
    use("tpope/vim-rsi")
    use("p00f/nvim-ts-rainbow")
    use("vimwiki/vimwiki")
    use("kevinhwang91/nvim-bqf")
    use("justinmk/vim-sneak")
    use("tpope/vim-surround")
    use("elihunter173/dirbuf.nvim")

    -- Colorscheme section
    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")

    -- Treesitter
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })
    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")

    -- Local
    --use("/home/jvernon/git/config/nvim-sql/")
end)
