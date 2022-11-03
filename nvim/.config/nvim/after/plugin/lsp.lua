local Remap = require("jvernon.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

--local sumneko_root_path = "/home/jvernon/personal/sumneko"
--local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup mason
require("mason").setup()
require("mason-lspconfig").setup()

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
    ensure_installed = {
        "omnisharp",
        "html",
        "quick_lint_js",
        --"lua-language-server",
        "sqlls",
        "tsserver",
    },
    automatic_installation = true
})

mason_lspconfig.setup_handlers({
    function(server_name)
        -- see if current directory contains panopto-core
        if vim.fn.getcwd():find("panopto") and server_name == "omnisharp" then
            -- skip omnisharp if we're in a panopto directory
            return
        end

        require("lspconfig")[server_name].setup({
            on_attach = function(client, bufnr)
                vim.keymap.set('n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
                vim.keymap.set('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
                vim.keymap.set('n', 'gh', "<Cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
                vim.keymap.set('n', 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
                vim.keymap.set('n', 'gm', "<Cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
                vim.keymap.set('n', 'gl', "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", bufopts)
                vim.keymap.set('n', 'gd', "<Cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
                vim.keymap.set('n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>", bufopts)
                vim.keymap.set('n', 'gn', "<Cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
                -- vim.keymap.set('n', 'gs', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", bufopts)
                vim.keymap.set('n', 'gs', "<Cmd>SymbolsOutline<CR>", bufopts)
                vim.keymap.set('n', 'gw', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", bufopts)
                vim.keymap.set('n', '[x', "<Cmd>lua vim.diagnostic.goto_prev()<CR>", bufopts)
                vim.keymap.set('n', ']x', "<Cmd>lua vim.diagnostic.goto_next()<CR>", bufopts)
                vim.keymap.set('n', ']r', "<Cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
                vim.keymap.set('n', ']s', "<Cmd>lua vim.diagnostic.show()<CR>", bufopts)

                local id = vim.api.nvim_create_augroup("SharedLspFormatting", { clear = true })
                vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                    group = id,
                    pattern = "*",
                    command = "lua vim.lsp.buf.format()",
                })
            end
        })
    end
})

-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
    copilot = "[Copilot]",
}

local lspkind = require("lspkind")

local function has_words_before()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
    }),
    formatting = {
        --insert_text = require("copilot_cmp.format").remove_existing,
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail .. " " .. menu
                end
                vim_item.kind = ""
            end
            vim_item.menu = menu
            return vim_item
        end,
    },
    sources = {
        { name = "copilot" },
        { name = "cmp_tabnine" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    },
    confirmation = { default_behaviour = cmp.ConfirmBehavior.Replace },
})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = "..",
})

--local function config(_config)
--	return vim.tbl_deep_extend("force", {
--		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--		on_attach = function()
--			nnoremap("gd", function() vim.lsp.buf.definition() end)
--			nnoremap("K", function() vim.lsp.buf.hover() end)
--			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
--			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
--			nnoremap("[d", function() vim.diagnostic.goto_next() end)
--			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
--			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
--			nnoremap("<leader>vco", function() vim.lsp.buf.code_action({
--                filter = function(code_action)
--                    if not code_action or not code_action.data then
--                        return false
--                    end
--
--                    local data = code_action.data.id
--                    return string.sub(data, #data - 1, #data) == ":0"
--                end,
--                apply = true
--            }) end)
--			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
--			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
--			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
--		end,
--	}, _config or {})
--end
--
--require("lspconfig").zls.setup(config())
--
--require("lspconfig").tsserver.setup(config())
--
--require("lspconfig").ccls.setup(config())
--
--require("lspconfig").jedi_language_server.setup(config())
--
--require("lspconfig").svelte.setup(config())
--
--require("lspconfig").solang.setup(config())
--
--require("lspconfig").cssls.setup(config())
--
--require("lspconfig").gopls.setup(config({
--	cmd = { "gopls", "serve" },
--	settings = {
--		gopls = {
--			analyses = {
--				unusedparams = true,
--			},
--			staticcheck = true,
--		},
--	},
--}))
--
---- who even uses this?
--require("lspconfig").rust_analyzer.setup(config({
--	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
--	--[[
--    settings = {
--        rust = {
--            unstable_features = true,
--            build_on_save = false,
--            all_features = true,
--        },
--    }
--    --]]
--}))
--
--require("lspconfig").sumneko_lua.setup(config({
--	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
--	settings = {
--		Lua = {
--			runtime = {
--				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--				version = "LuaJIT",
--				-- Setup your lua path
--				path = vim.split(package.path, ";"),
--			},
--			diagnostics = {
--				-- Get the language server to recognize the `vim` global
--				globals = { "vim" },
--			},
--			workspace = {
--				-- Make the server aware of Neovim runtime files
--				library = {
--					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
--					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--				},
--			},
--		},
--	},
--}))

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
    local plugins = { "friendly-snippets" }
    local paths = {}
    local path
    local root_path = vim.env.HOME .. "/.vim/plugged/"
    for _, plug in ipairs(plugins) do
        path = root_path .. plug
        if vim.fn.isdirectory(path) ~= 0 then
            table.insert(paths, path)
        end
    end
    return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
    paths = snippets_paths(),
    include = nil, -- Load all languages
    exclude = {},
})
