return {
    -- {
    --     "windwp/nvim-autopairs",
    --     event = "InsertEnter",
    --     opts = {
    --         enable_abbr = true,
    --         fast_wrap = {
    --             map = "<M-e>",
    --             chars = { "{", "[", "(", '"', "'" },
    --             pattern = [=[[%'%"%>%]%)%}%,]]=],
    --             end_key = "$",
    --             before_key = "h",
    --             after_key = "l",
    --             cursor_pos_before = true,
    --             keys = "qwertyuiopzxcvbnmasdfghjkl",
    --             manual_position = true,
    --             highlight = "Search",
    --             highlight_grey = "Comment",
    --         },
    --     },
    --     config = function(_, opts)
    --         local autopair = require("nvim-autopairs")
    --         local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    --         local cmp_status, cmp = pcall(require, "cmp")
    --
    --         autopair.setup(opts)
    --
    --         if cmp_status then
    --             cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    --
    --             local handlers = require("nvim-autopairs.completion.handlers")
    --
    --             cmp.event:on(
    --                 "confirm_done",
    --                 cmp_autopairs.on_confirm_done({
    --                     filetypes = {
    --                         -- "*" is a alias to all filetypes
    --                         ["*"] = {
    --                             ["("] = {
    --                                 kind = {
    --                                     cmp.lsp.CompletionItemKind.Function,
    --                                     cmp.lsp.CompletionItemKind.Method,
    --                                 },
    --                                 handler = handlers["*"],
    --                             },
    --                         },
    --                         lua = {
    --                             ["("] = {
    --                                 kind = {
    --                                     cmp.lsp.CompletionItemKind.Function,
    --                                     cmp.lsp.CompletionItemKind.Method,
    --                                 },
    --                                 ---@param char string
    --                                 ---@param item table item completion
    --                                 ---@param bufnr number buffer number
    --                                 ---@param rules table
    --                                 ---@param commit_character table<string>
    --                                 handler = function(char, item, bufnr, rules, commit_character)
    --                                     -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
    --                                 end,
    --                             },
    --                         },
    --                         -- Disable for tex
    --                         tex = false,
    --                     },
    --                 })
    --             )
    --         end
    --     end,
    -- },
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = not vim.g.vscode,
        branch = "v0.6", --recommended as each new version will have breaking changes
        opts = {
            tabout = {
                enable = true,
                map = "<A-b>",
                cmap = "<A-b>",
                hopout = true,
            },
            cr = { enable = true },
            bs = { enable = true },
            close = { enable = true },
            space2 = { enable = true },
        },
    },
}
