local lsp_utils = require("lsp_utils")

vim.diagnostic.config(lsp_utils.default_diagnostic_config)

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSign" .. "Error",
            [vim.diagnostic.severity.WARN] = "DiagnosticSign" .. "Warn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSign" .. "Hint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSign" .. "Info",
        },
    },
})

-- Disabled as using Noice for this
local hover_opts = {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
    -- add the title in hover float window
    -- title = "hover",
    relative = "win",
    max_height = math.floor(vim.o.lines * 0.6),
    max_width = math.floor(vim.o.columns * 0.5),
}
if not vim.g.neovide then
    -- [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ].
    hover_opts.border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }
end
local status_noice, _ = pcall(require, "noice")
local status_hover, _ = pcall(require, "hover")
if not (status_noice or status_hover) then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_opts)
end

local signature_help_opts = {
    -- title = "signature help",
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
        "InsertLeave",
    },
    padding = { 0, 0 },
}
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, signature_help_opts)

vim.keymap.set({ "n" }, "<F13>k", lsp_utils.open_diagnostics_float, { desc = "Open diagnostics float", noremap = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
