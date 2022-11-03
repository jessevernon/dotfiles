local Remap = require("jvernon.keymap")
local nnoremap = Remap.nnoremap

--nnoremap("<C-p>", ":Telescope")
--nnoremap("<leader>ps", function()
--    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })
--end)
--nnoremap("<C-p>", function()
--    require('telescope.builtin').git_files()
--end)
--nnoremap("<Leader>pf", function()
--    require('telescope.builtin').find_files()
--end)
--
--nnoremap("<leader>pw", function()
--    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
--end)
--nnoremap("<leader>pb", function()
--    require('telescope.builtin').buffers()
--end)
--nnoremap("<leader>vh", function()
--    require('telescope.builtin').help_tags()
--end)
--
--nnoremap("<leader>vwh", function()
--    require('telescope.builtin').help_tags()
--end)
--
--nnoremap("<leader>vrc", function()
--    require('jvernon.telescope').search_dotfiles({ hidden = true })
--end)
--nnoremap("<leader>gc", function()
--    require('jvernon.telescope').git_branches()
--end)
--nnoremap("<leader>gw", function()
--    require('telescope').extensions.git_worktree.git_worktrees()
--end)
--nnoremap("<leader>gm", function()
--    require('telescope').extensions.git_worktree.create_git_worktree()
--end)
--nnoremap("<leader>td", function()
--    require('jvernon.telescope').dev()
--end)

-- FZF native
-- Sort buffers by most recently used
require("telescope").setup({
    pickers = {
        buffers = { sort_mru = true, ignore_current_buffer = true }
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
