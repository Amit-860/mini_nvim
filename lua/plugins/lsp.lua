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
            local icons = require('icons')
            local utils = require("utils")
            local default_diagnostic_config = {
                signs = {
                    active = true,
                    values = {
                        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
                        { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
                        { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
                        { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
                    },
                },
                virtual_text = {
                    source = "if_many",
                    -- prefix = '●',
                    prefix = "⏺ "
                },
                virtual_lines = false,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "single",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }
            vim.diagnostic.config(default_diagnostic_config)

            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end


            local open_diagnostics = function()
                vim.diagnostic.open_float({
                    scope = "cursor",
                    focusable = false,
                    border = "single",
                    close_events = {
                        "CursorMoved",
                        "CursorMovedI",
                        "BufHidden",
                        "InsertCharPre",
                        "WinLeave",
                        "InsertEnter",
                        "InsertLeave"
                    },
                })
            end

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
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
            local on_attach = function(client, bufnr)
                -- NOTE: inlay hint
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(false)
                end

                -- NOTE: code_lens
                if client.server_capabilities.codeLensProvider then
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                        buffer = bufnr,
                        callback = vim.lsp.codelens.refresh,
                    })
                end

                -- lsp keymap
                -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
                vim.keymap.set({ "n", "i" }, "<F13>k", open_diagnostics,
                    { desc = "Signature Help", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n", "i" }, "<M-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                    { desc = "Signature Help", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
                    { desc = "Hover", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
                    { desc = "Code Action", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>lr",
                    "<cmd>Telescope lsp_references theme=get_ivy initial_mode=normal<CR>",
                    { desc = "References", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>lR", function()
                        require('utils').lsp_rename()
                    end,
                    { desc = "Rename Symbol", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>ld",
                    "<cmd>Telescope lsp_definitions theme=get_ivy initial_mode=normal<CR>",
                    { desc = "Definitions", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>li",
                    "<cmd>Telescope lsp_implementations theme=get_ivy initial_mode=normal<CR>",
                    { desc = "Implementations", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>",
                    { desc = "Workspace Symbols", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>lD",
                    "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy initial_mode=normal<CR>",
                    { desc = "Diagnostics", noremap = true, buffer = bufnr })
                vim.keymap.set({ "n" }, "<leader>lf", function() vim.lsp.buf.format() end,
                    { desc = "Format", noremap = true, buffer = bufnr })

                -- toggle inlay_hint
                vim.keymap.set({ "n" }, "<leader>lH",
                    function()
                        local hint_flag = not vim.lsp.inlay_hint.is_enabled()
                        vim.lsp.inlay_hint.enable(hint_flag)
                    end,
                    { desc = "Virtual Hints", noremap = true, silent = false, buffer = bufnr })

                -- lsp lines globally
                local lsp_lines_enable = false
                vim.keymap.set("n", "<leader>lh",
                    function()
                        if not lsp_lines_enable then
                            default_diagnostic_config.virtual_text = false
                            default_diagnostic_config.virtual_lines = true
                            lsp_lines_enable = true
                        else
                            default_diagnostic_config.virtual_text = {
                                source = "if_many",
                                -- prefix = '●',
                                prefix = "⏺ "
                            }
                            default_diagnostic_config.virtual_lines = false
                            lsp_lines_enable = false
                        end
                        vim.diagnostic.config(default_diagnostic_config)
                    end,
                    { desc = "Toggle HlChunk", noremap = true }
                )

                -- enable lsplines for curr line
                local lsp_lines_curr_line_enabled = false
                vim.keymap.set("n", "<F13>l",
                    function()
                        if lsp_lines_enable then return end
                        if not lsp_lines_curr_line_enabled then
                            default_diagnostic_config.virtual_lines = { only_current_line = true }
                            lsp_lines_curr_line_enabled = true
                        else
                            default_diagnostic_config.virtual_lines = false
                            lsp_lines_curr_line_enabled = false
                        end
                        vim.diagnostic.config(default_diagnostic_config)
                    end,
                    { desc = "HlChunk .", noremap = true }
                )
                -- autocmd to disable per line HlChunk
                vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" }, {
                    group = vim.api.nvim_create_augroup("Diaable_hlchunk", { clear = true }),
                    callback = function()
                        if default_diagnostic_config.virtual_lines then
                            default_diagnostic_config.virtual_lines = false
                            default_diagnostic_config.virtual_text = {
                                source = "if_many",
                                -- prefix = '●',
                                prefix = "⏺ "
                            }
                            vim.diagnostic.config(default_diagnostic_config)
                            lsp_lines_curr_line_enabled = false
                        end
                    end,
                })

                -- Code Runner
                vim.keymap.set("n", "<leader>r", "<nop>", { desc = "which_key_ignore", noremap = true })
                vim.keymap.set("n", "<leader>rc", function()
                    local file_type = vim.bo.filetype
                    utils.code_runner(file_type, "horizontal") -- float, window, horizontal, vertical
                end, { silent = true, desc = "Run Code", })

                vim.keymap.set("n", "<F4>", function()
                    local file_type = vim.bo.filetype
                    require('pluginSetups.toggleTermConfig').code_runner(file_type)
                end, { noremap = true, silent = true, desc = "Run Code", })
            end


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


            -- NOTE : lsp autocmds
            local lsp_attach_aug = vim.api.nvim_create_augroup("lsp_attach_aug", { clear = true })
            vim.api.nvim_create_autocmd({ "LspAttach" }, {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    on_attach(client, 0)
                end,
                group = lsp_attach_aug,
            })
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                group = lsp_attach_aug,
                pattern = { "*.java" },
                callback = function()
                    local _, _ = pcall(vim.lsp.codelens.refresh)
                end,
            })
        end
    }
}