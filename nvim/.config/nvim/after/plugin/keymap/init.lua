local Remap = require("jvernon.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap
local noremap = Remap.noremap
local nmap = Remap.nmap

-- Mappings!

-- Terminal settings <leader>ESCp+
tnoremap("<leader><ESC>", "<C-\\><C-n>")
tnoremap("<leader>p", "<C-\\><C-N>\"0pi")
tnoremap("<leader>+", "<C-\\><C-N>\"+pi")

-- Navigation LHKJ
noremap("<C-h>", "<C-w>h")
noremap("<C-j>", "<C-w>j")
noremap("<C-k>", "<C-w>k")
noremap("<C-l>", "<C-w>l")
noremap("L", "<C-d>")
noremap("H", "<C-u>")
noremap("K", "[{")
noremap("J", "[}")

-- Text searching <leader>hjkl
nnoremap("<leader>j", ":grep! \"\" | cw<Left><Left><Left><Left><Left><Left>")
nnoremap("<leader>k", ":grep! \"\\b<cword>\\b\"<CR>:cw<CR>")
nnoremap("<leader>l", ":Telescope quickfix")
nnoremap("<leader>;", ":Telescope quickfixhistory")
vnoremap("<leader>k", ":<C-U>execute('grep! \"\\b' . Get_visual_selection() . '\\b\"')<CR>:cw<CR>")

-- Text editing
noremap("<leader>d", "\"_d")
noremap("<leader>u", "J")
inoremap("<C-r>", "<C-g>u<C-r>")
nnoremap("<leader>h", ":noh<CR>")
nnoremap("<leader>.", ";")
nnoremap("gp", "`[v`]")
inoremap("<C-n>", "<ESC>:Copilot panel<CR>")

-- Enter highlight function
vim.g.highlighting = false
nnoremap(
    "<CR>",
    function()
        local current_word_regex = string.format("^\\<%s\\>$", vim.fn.expand("<cword>"))
        local current_word_regex_double_escaped = string.format("\\\\<%s\\\\>", vim.fn.expand("<cword>"))
        if vim.bo.buftype == "quickfix" then
            return "<CR>"
        elseif vim.g.highlighting == true
            and vim.cmd("echo @/") == current_word_regex
        then
            vim.g.highlighting = false
            return ":silent nohlsearch<CR>"
        else
            vim.cmd(string.format("let @/=\"%s\"", current_word_regex_double_escaped))
            vim.g.highlighting = true
            return ":silent set hlsearch<CR>"
        end
    end,
    { expr = true, silent = true }
)

-- Quickfix / loclist <leader>nm,.M<>
noremap("<leader>n", ":cn<CR>")
noremap("<leader>m", ":if empty(filter(getwininfo(), 'v:val.quickfix')) | copen | else | cclose | endif<CR>")
noremap("<leader>N", ":ln<CR>")
noremap("<leader>M", ":if empty(filter(getwininfo(), 'v:val.quickfix')) | lopen | else | lclose | endif<CR>")

-- IDE <leader>ert
-- map <leader>t :NERDTreeToggle<CR>
-- map <leader>T :NERDTreeFind<CR>
--map <leader>t :NvimTreeToggle<CR>
--map <leader>T :NvimTreeFindFile<CR>
--map <leader>r :TagbarToggle<CR>
--map <leader>e :call GstatusToggle()<CR>

-- Tag jumping <leader>zxcvb
--noremap("<leader>z", ":tjump<CR>")
--noremap("<leader>Z", ":stjump<CR>")
--noremap("<leader>x", ":ptjump<CR>")
--noremap("<leader>X", ":pclose<CR>")
--noremap("<leader>c", ":lt <cword> \| lopen<CR>")
--noremap("<leader>V", ":tp<CR>")
--noremap("<leader>v", ":tn<CR>")

-- Buffers <leader>qwQ
noremap("<leader>q", ":b#<CR>")
tnoremap("<leader>q", "<C-\\><C-n>:b#<CR>")
noremap("<leader>w", ":only<CR>")
--tmap <leader>w <C-\\><C-n>:only<CR>
noremap("<leader>W", ":close<CR>")
--tmap <leader>W <C-\\><C-n>:close<CR>

-- FZF <leader>asdfg
noremap("<leader>a", ":Telescope current_buffer_fuzzy_find<CR>")
tnoremap("<leader>a", "<C-\\><C-n>:Telescope current_buffer_fuzzy_find<CR>")
noremap("<leader>s", ":Telescope treesitter<CR>")
--tnoremap("<leader>s", "<C-\\><C-n>:Telescope treesitter<CR>")
noremap("<leader>b", ":Telescope buffers<CR>")
tnoremap("<leader>b", "<C-\\><C-n>:Telescope buffers<CR>")
noremap("<leader>f", ":Telescope jumplist<CR>")
tnoremap("<leader>f", "<C-\\><C-n>:Telescope jumplist<CR>")
--noremap("<leader>g", ":Telescope find_files<CR>")
nnoremap("<Leader>g", function()
    require('telescope.builtin').find_files()
end)
tnoremap("<leader>g", "<C-\\><C-n>:Telescope find_files<CR>")
noremap("<leader>G", ":Telescope oldfiles<CR>")
tnoremap("<leader>G", "<C-\\><C-n>:Telescope oldfiles<CR>")

vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

nnoremap("Y", "yg$")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Fix :W mistake
--vim.api.nvim_create_user_command()
--command! WQ wq
--command! Wq wq
--command! W w
--command! Q q

noremap("<leader>p", "\"+p")
noremap("<leader>y", "\"+y")

nnoremap("Q", "<nop>")
nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

--nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
--nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--
-- Pretty print XML
vim.cmd("command! PrettyXML :set filetype=xml | %!python3 -c \"import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())\"")

-- Pretty print Json
vim.cmd("command! PrettyJson :set filetype=json | %!python3 -m \"json.tool\"")
