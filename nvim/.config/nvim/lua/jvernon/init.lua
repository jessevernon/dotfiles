require("jvernon.set")
require("jvernon.packer")

local augroup = vim.api.nvim_create_augroup
local jvernon_group = augroup('jvernon', {})
local yank_group = augroup("HighlightYank", {})

local autocmd = vim.api.nvim_create_autocmd

-- reload function
function R(name)
    require("plenary.reload").reload_module(name)
end

-- highlight yanks
autocmd('TextYankPost', {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})
