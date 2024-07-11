return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason" },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy"
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            -- local icons = require('icons')
            -- local utils = require("utils")
            -- local lsp_utils = require('lsp_utils')
            -- local default_diagnostic_config = {
            --     signs = {
            --         active = true,
            --         values = {
            --             { name = "DiagnosticSignError", text = icons.diagnostics.Error },
            --             { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
            --             { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
            --             { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
            --         },
            --     },
            --     virtual_text = {
            --         source = "if_many",
            --         -- prefix = '●',
            --         prefix = "⏺ "
            --     },
            --     virtual_lines = false,
            --     update_in_insert = false,
            --     underline = true,
            --     severity_sort = true,
            --     float = {
            --         focusable = true,
            --         style = "minimal",
            --         border = "single",
            --         source = "always",
            --         header = "",
            --         prefix = "",
            --     },
            -- }
            -- vim.diagnostic.config(default_diagnostic_config)
            --
            -- local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            -- for type, icon in pairs(signs) do
            --     local hl = "DiagnosticSign" .. type
            --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            -- end
            --
            --
            -- local open_diagnostics_float = function()
            --     vim.diagnostic.open_float({
            --         scope = "cursor",
            --         focusable = false,
            --         border = "single",
            --         close_events = {
            --             "CursorMoved",
            --             "CursorMovedI",
            --             "BufHidden",
            --             "InsertCharPre",
            --             "WinLeave",
            --             "InsertEnter",
            --             "InsertLeave"
            --         },
            --     })
            -- end

            -- Disabled as using Noice for this
            -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            --     vim.lsp.handlers.hover, {
            --         -- Use a sharp border with `FloatBorder` highlights
            --         border = "none",
            --         -- add the title in hover float window
            --         -- title = "hover"
            --         relative = 'win',
            --         max_height = math.floor(vim.o.lines * 0.6),
            --         max_width = math.floor(vim.o.columns * 0.5),
            --         -- [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ].
            --     }
            -- )

            -- mason configs
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "basedpyright", "ruff", "jsonls", "ltex", "denols", "html", "cssls", "cssmodules_ls", "emmet_language_server" },
                automatic_installation = false,
            })

            -- Set up lspconfig.
            local lspconfig = require('lspconfig')

            -- setup lsp servers
            -- add any global capabilities here
            local capabilities_opts = {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            }
            local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_capabilities or {},
                capabilities_opts or {}
            )

            local function setup_lsp(server, opts)
                -- lspconfig[server].setup(opts)
                local conf = lspconfig[server]
                conf.setup(opts)
                local try_add = conf.manager.try_add
                conf.manager.try_add = function(bufnr)
                    return try_add(bufnr)
                end
            end

            -- NOTE: LSP on_attach func
            -- local on_attach = function(client, bufnr)
            --     -- NOTE: inlay hint
            --     local inlay_hint_flag = true
            --     -- if client.server_capabilities.inlayHintProvider then
            --     if inlay_hint_flag and client.supports_method "textDocument/inlayHint" then
            --         vim.lsp.inlay_hint.enable(false)
            --     end
            --
            --     -- NOTE: code_lens
            --     local code_lens_flag = false
            --     -- if client.server_capabilities.codeLensProvider then
            --     if code_lens_flag and client.supports_method "textDocument/codeLens" then
            --         vim.lsp.codelens.refresh()
            --         vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            --             buffer = bufnr,
            --             callback = vim.lsp.codelens.refresh,
            --         })
            --     end
            --
            --
            --
            --
            --
            --     -- NOTE: ---------------------------------------------
            --
            --     local supports_method = {}
            --     local register_capability = vim.lsp.handlers["client/registerCapability"]
            --     vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
            --         ---@diagnostic disable-next-line: no-unknown
            --         local ret = register_capability(err, res, ctx)
            --         local client = vim.lsp.get_client_by_id(ctx.client_id)
            --         if client then
            --             for buffer in pairs(client.attached_buffers) do
            --                 vim.api.nvim_exec_autocmds("User", {
            --                     pattern = "LspDynamicCapability",
            --                     data = { client_id = client.id, buffer = buffer },
            --                 })
            --             end
            --         end
            --         return ret
            --     end
            --
            --     ---@param fn fun(client:vim.lsp.Client, buffer):boolean?
            --     ---@param opts? {group?: integer}
            --     local function on_dynamic_capability(fn, opts)
            --         return vim.api.nvim_create_autocmd("User", {
            --             pattern = "LspDynamicCapability",
            --             group = opts and opts.group or nil,
            --             callback = function(args)
            --                 local client = vim.lsp.get_client_by_id(args.data.client_id)
            --                 local buffer = args.data.buffer ---@type number
            --                 if client then
            --                     return fn(client, buffer)
            --                 end
            --             end,
            --         })
            --     end
            --
            --     ---@param client vim.lsp.Client
            --     local function check_methods(client, buffer)
            --         -- don't trigger on invalid buffers
            --         if not vim.api.nvim_buf_is_valid(buffer) then
            --             return
            --         end
            --         -- don't trigger on non-listed buffers
            --         if not vim.bo[buffer].buflisted then
            --             return
            --         end
            --         -- don't trigger on nofile buffers
            --         if vim.bo[buffer].buftype == "nofile" then
            --             return
            --         end
            --         for method, clients in pairs(supports_method) do
            --             clients[client] = clients[client] or {}
            --             if not clients[client][buffer] then
            --                 if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
            --                     clients[client][buffer] = true
            --                     vim.api.nvim_exec_autocmds("User", {
            --                         pattern = "LspSupportsMethod",
            --                         data = { client_id = client.id, buffer = buffer, method = method },
            --                     })
            --                 end
            --             end
            --         end
            --     end
            --
            --     on_dynamic_capability(check_methods)
            --
            --
            --     local words = {}
            --     words.enabled = false
            --     words.ns = vim.api.nvim_create_namespace("vim_lsp_references")
            --
            --     ---@param opts? {enabled?: boolean}
            --     function words.setup(opts)
            --         opts = opts or {}
            --         if not opts.enabled then
            --             return
            --         end
            --         words.enabled = true
            --         local handler = vim.lsp.handlers["textDocument/documentHighlight"]
            --         vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
            --             if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
            --                 return
            --             end
            --             vim.lsp.buf.clear_references()
            --             return handler(err, result, ctx, config)
            --         end
            --
            --         if client.supports_method "textDocument/documentHighlight" then
            --             vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
            --                 group = vim.api.nvim_create_augroup("lsp_word_" .. bufnr, { clear = true }),
            --                 buffer = bufnr,
            --                 callback = function(ev)
            --                     if not ({ words.get() })[2] then
            --                         if ev.event:find("CursorMoved") then
            --                             vim.lsp.buf.clear_references()
            --                         elseif not require('cmp').visible() then
            --                             vim.lsp.buf.document_highlight()
            --                         end
            --                     end
            --                 end,
            --             })
            --         end
            --     end
            --
            --     words.setup({ enabled = true })
            --
            --     ---@return LspWord[] words, number? current
            --     function words.get()
            --         local cursor = vim.api.nvim_win_get_cursor(0)
            --         local current, ret = nil, {} ---@type number?, LspWord[]
            --         for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, words.ns, 0, -1, { details = true })) do
            --             local w = {
            --                 from = { extmark[2] + 1, extmark[3] },
            --                 to = { extmark[4].end_row + 1, extmark[4].end_col },
            --             }
            --             ret[#ret + 1] = w
            --             if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
            --                 current = #ret
            --             end
            --         end
            --         return ret, current
            --     end
            --
            --     ---@param count number
            --     ---@param cycle? boolean
            --     function words.jump(count, cycle)
            --         local words, idx = words.get()
            --         if not idx then
            --             return
            --         end
            --         idx = idx + count
            --         if cycle then
            --             idx = (idx - 1) % #words + 1
            --         end
            --         local target = words[idx]
            --         if target then
            --             vim.api.nvim_win_set_cursor(0, target.from)
            --         end
            --     end
            --
            --     -------------------------------------------------------------
            --
            --
            --
            --     -- lsp keymap
            --     -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
            --     vim.keymap.set({ "n", "i" }, "<F13>k", open_diagnostics_float,
            --         { desc = "Signature Help", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n", "i" }, "<M-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
            --         { desc = "Signature Help", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
            --         { desc = "Hover", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
            --         { desc = "Code Action", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>lr",
            --         "<cmd>Telescope lsp_references theme=get_ivy initial_mode=normal<CR>",
            --         { desc = "References", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>lR", function()
            --             require('utils').lsp_rename()
            --         end,
            --         { desc = "Rename Symbol", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>ld",
            --         "<cmd>Telescope lsp_definitions theme=get_ivy initial_mode=normal<CR>",
            --         { desc = "Definitions", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>li",
            --         "<cmd>Telescope lsp_implementations theme=get_ivy initial_mode=normal<CR>",
            --         { desc = "Implementations", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>",
            --         { desc = "Workspace Symbols", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>lD",
            --         "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy initial_mode=normal<CR>",
            --         { desc = "Diagnostics", noremap = true, buffer = bufnr })
            --     vim.keymap.set({ "n" }, "<leader>lf", function() vim.lsp.buf.format() end,
            --         { desc = "Format", noremap = true, buffer = bufnr })
            --
            --     -- toggle inlay_hint
            --     vim.keymap.set({ "n" }, "<leader>lH",
            --         function()
            --             local hint_flag = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            --             vim.lsp.inlay_hint.enable(hint_flag)
            --         end,
            --         { desc = "Virtual Hints", noremap = true, silent = false, buffer = bufnr })
            --
            --     -- lsp lines globally
            --     local lsp_lines_enable = false
            --     vim.keymap.set("n", "<leader>lh",
            --         function()
            --             if not lsp_lines_enable then
            --                 default_diagnostic_config.virtual_text = false
            --                 default_diagnostic_config.virtual_lines = true
            --                 lsp_lines_enable = true
            --             else
            --                 default_diagnostic_config.virtual_text = {
            --                     source = "if_many",
            --                     -- prefix = '●',
            --                     prefix = "⏺ "
            --                 }
            --                 default_diagnostic_config.virtual_lines = false
            --                 lsp_lines_enable = false
            --             end
            --             vim.diagnostic.config(default_diagnostic_config)
            --         end,
            --         { desc = "Toggle HlChunk", noremap = true }
            --     )
            --
            --     -- enable lsplines for curr line
            --     local lsp_lines_curr_line_enabled = false
            --     vim.keymap.set("n", "<F13>l",
            --         function()
            --             if lsp_lines_enable then return end
            --             if not lsp_lines_curr_line_enabled then
            --                 default_diagnostic_config.virtual_lines = { only_current_line = true }
            --                 lsp_lines_curr_line_enabled = true
            --             else
            --                 default_diagnostic_config.virtual_lines = false
            --                 lsp_lines_curr_line_enabled = false
            --             end
            --             vim.diagnostic.config(default_diagnostic_config)
            --         end,
            --         { desc = "HlChunk .", noremap = true }
            --     )
            --     -- autocmd to disable per line HlChunk
            --     vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" }, {
            --         group = vim.api.nvim_create_augroup("Diaable_hlchunk", { clear = true }),
            --         callback = function()
            --             if default_diagnostic_config.virtual_lines then
            --                 default_diagnostic_config.virtual_lines = false
            --                 default_diagnostic_config.virtual_text = {
            --                     source = "if_many",
            --                     -- prefix = '●',
            --                     prefix = "⏺ "
            --                 }
            --                 vim.diagnostic.config(default_diagnostic_config)
            --                 lsp_lines_curr_line_enabled = false
            --             end
            --         end,
            --     })
            --
            --     -- Code Runner
            --     vim.keymap.set("n", "<leader>r", "<nop>", { desc = "which_key_ignore", noremap = true })
            --     vim.keymap.set("n", "<leader>rc", function()
            --         local file_type = vim.bo.filetype
            --         utils.code_runner(file_type, "horizontal") -- float, window, horizontal, vertical
            --     end, { silent = true, desc = "Run Code", })
            --
            --     vim.keymap.set("n", "<F4>", function()
            --         local file_type = vim.bo.filetype
            --         require('pluginSetups.toggleTermConfig').code_runner(file_type)
            --     end, { noremap = true, silent = true, desc = "Run Code", })
            -- end


            -- NOTE: ===================== setting up servers ======================

            -- comment below line to disable lsp support for nvim files
            -- NOTE : neodev for nvim apis
            -- require("neodev").setup({})


            -- NOTE : lua
            local lua_ls_settings = {
                Lua = {
                    workspace = { checkThirdParty = false, },
                    codeLens = { enable = false, },
                    completion = { callSnippet = "Replace", },
                    doc = { privateName = { "^_" }, },
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = true,
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                    }
                }
            }
            setup_lsp("lua_ls", { on_attach = on_attach, capabilities = capabilities, settings = lua_ls_settings, })

            -- NOTE : python
            local basedpyright_settings = {
                basedpyright = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = 'basic' -- ["off", "basic", "standard", "strict", "all"]
                    }
                }
            }
            setup_lsp("basedpyright",
                { on_attach = on_attach, capabilities = capabilities, settings = basedpyright_settings })
            setup_lsp("ruff", { on_attach = on_attach, capabilities = capabilities, })

            -- NOTE : Json
            setup_lsp("jsonls", { on_attach = on_attach, capabilities = capabilities, })

            -- NOTE : text
            setup_lsp("ltex",
                { on_attach = on_attach, capabilities = capabilities, filetypes = { 'gitcommit', 'markdown', 'org', 'norg', 'xhtml', } }
            )

            -- NOTE : javascript, html, css
            vim.g.markdown_fenced_languages = { "ts=typescript" }
            setup_lsp("denols", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("html", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("cssls", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("cssmodules_ls", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("emmet_language_server", { on_attach = on_attach, capabilities = capabilities, })


            -- -- NOTE : lsp autocmds
            -- local lsp_attach_aug = vim.api.nvim_create_augroup("lsp_attach_aug", { clear = true })
            -- vim.api.nvim_create_autocmd({ "LspAttach" }, {
            --     callback = function(args)
            --         local client = vim.lsp.get_client_by_id(args.data.client_id)
            --         on_attach(client, 0)
            --     end,
            --     group = lsp_attach_aug,
            -- })
            -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            --     group = lsp_attach_aug,
            --     pattern = { "*.java" },
            --     callback = function()
            --         local _, _ = pcall(vim.lsp.codelens.refresh)
            --     end,
            -- })
        end
    }
}
