local calendar = require("local.calendar")
local dashboard_opts = {
    enabled = true,
    width = 64,
    pane_gap = 5,
    preset = {
        keys = {
            {
                icon = "  ",
                key = "N",
                desc = "New file",
                action = function()
                    vim.cmd("enew")
                end,
            },
            {
                icon = "󱋢  ",
                desc = "Recent files",
                key = "R",
                -- action = function()
                --     vim.cmd("Telescope oldfiles layout_strategy=horizontal layout_config={preview_width=0.5}")
                -- end,
                action = function()
                    require("telescope").extensions.frecency.frecency({
                        initial_mode = "insert",
                        layout_strategy = "horizontal",
                        layout_config = { preview_width = 0.5 },
                        path_display = { "shorten" },
                    })
                end,
            },
            {
                icon = "󰮗  ",
                desc = "Find file",
                key = "F",
                action = function()
                    require("utils").smart_find_file({})
                end,
            },
            {
                icon = "  ",
                desc = "File explorer",
                key = "E",
                action = function()
                    require("yazi").yazi(nil, vim.fn.getcwd())
                end,
            },
            {
                icon = "  ",
                desc = "Find session",
                key = "S",
                action = function()
                    -- require("persistence").load({ last = true })
                    vim.cmd("Telescope persisted theme=dropdown")
                end,
            },
            {
                icon = "  ",
                desc = "Last session",
                key = "L",
                action = function()
                    -- require("persistence").load({ last = true })
                    vim.cmd("SessionLoadLast")
                end,
            },
            {
                icon = "  ",
                desc = "LeetCode",
                key = "T",
                action = function()
                    vim.cmd("Leet")
                end,
            },
            {
                icon = "  ",
                desc = "Projects",
                key = "P",
                action = function()
                    require("telescope").extensions.project.project({ display_type = "full" })
                end,
            },
            {
                icon = "  ",
                desc = "NeoGit",
                key = "G",
                action = function()
                    vim.cmd("Neogit")
                end,
            },
            {
                icon = "  ",
                desc = "Configs",
                key = "C",
                key_hl = "DashboardButtonShortcut",
                action = function()
                    require("telescope.builtin").find_files({
                        find_command = {
                            "fd",
                            "-tf",
                            "-H",
                            "-E",
                            ".git",
                            ".",
                            vim.fn.expand("$HOME/AppData/Local/nvim"),
                        },
                    })
                end,
            },
            {
                icon = "󰿅  ",
                desc = "Quit",
                key = "Q",
                action = function()
                    vim.cmd("q")
                end,
            },
        },
        header = calendar.createOutput(),
    },
    formats = {
        header = { "%s", align = "left" },
    },
    sections = {
        --INFO : Pane -- 1
        {
            pane = 1,
            text = {
                { "  CWD: ", hl = "footer" },
                { vim.fn.getcwd(), hl = "special" },
            },
            indent = 0,
            padding = 1,
        },
        {
            pane = 1,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
                return Snacks.git.get_root() ~= nil
            end,
            cmd = "git --no-pager diff --stat --stat-graph-width=28 -B -M -C",
            -- cmd = "git -c color.status=always status -sb --ignore-submodules=dirty && git diff --shortstat",
            key = "-",
            action = function()
                Snacks.lazygit()
            end,
            height = 9,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
        },
        -- { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 2 },
        {
            pane = 1,
            icon = " ",
            title = "Sessions",
            section = "projects",
            indent = 3,
            padding = 3,
            limit = 8,
            height = 10,
        },

        --INFO : Pane -- 2
        { pane = 2, text = { calendar.createOutput(), hl = "SnacksDashboardDesc" }, padding = 0 },
        { pane = 2, section = "keys", gap = 0, padding = 1 },
        function()
            local lazy_stats = require("lazy.stats").stats()
            local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
            return {
                pane = 2,
                align = "right",
                text = {
                    { "⚡", hl = "DevIconPy" },
                    { "Neovim loaded ", hl = "footer" },
                    { lazy_stats.loaded .. "", hl = "String" },
                    { "/", hl = "special" },
                    { lazy_stats.count .. "", hl = "CmpItemAbbr" },
                    { " plugins in ", hl = "footer" },
                    { ms .. "ms", hl = "Error" },
                },
            }
        end,
    },
}

return {
    "folke/snacks.nvim",
    cond = not vim.g.vscode,
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = dashboard_opts,
        notifier = {
            enabled = true,
            -- your notifier configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        quickfile = {
            enabled = true,
            -- your quickfile configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        scratch = {
            enabled = true,
        },
        toggle = {
            enabled = true,
            -- your toggle configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
            scratch = {
                height = math.floor(vim.o.lines * 0.85),
                width = math.floor(vim.o.columns * 0.85),
                bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
                minimal = false,
                noautocmd = false,
                -- position = "right",
                zindex = 20,
                wo = { winhighlight = "NormalFloat:Normal" },
                border = "single",
                title_pos = "center",
                footer_pos = "center",
            },
        },
        lazygit = {
            enabled = true,
            -- your lazygit configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        statuscolumn = {
            enabled = true,
            left = { "mark", "sign" }, -- priority of signs on the left (high to low)
            right = { "git", "fold" }, -- priority of signs on the right (high to low)
            folds = {
                open = true, -- show open fold icons
                git_hl = true, -- use Git Signs hl for fold icons
            },
            git = {
                -- patterns to match Git signs
                patterns = { "GitSign", "MiniDiffSign" },
            },
            refresh = 100, -- refresh at most every 50ms
        },
        -- bigfile = {
        --     notify = true, -- show notification when big file detected
        --     size = 2 * 1024 * 1024, -- 1.5MB
        --     -- Enable or disable features when big file detected
        --     ---@param ctx {buf: number, ft:string}
        --     setup = function(ctx)
        --         vim.cmd([[NoMatchParen]])
        --         vim.cmd("IlluminatePauseBuf")
        --         vim.cmd("IBLDisable")
        --         pcall(function()
        --             require("lualine").hide()
        --         end)
        --         Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        --         vim.b.minianimate_disable = true
        --         vim.schedule(function()
        --             vim.bo[ctx.buf].syntax = ctx.ft
        --         end)
        --     end,
        -- },
    },
    keys = {
        {
            "<F13>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<F13>?",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select Scratch Buffer",
        },
        {
            "<F13>h",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "Notification History",
        },
        {
            "<F13>gb",
            function()
                Snacks.git.blame_line()
            end,
            desc = "Git Blame Line",
        },
        {
            "<F13>gl",
            function()
                Snacks.lazygit.log_file()
            end,
            desc = "Lazygit Current File History",
        },
        {
            "<F13>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
        {
            "<F13>gL",
            function()
                Snacks.lazygit.log()
            end,
            desc = "Lazygit Log (cwd)",
        },
        {
            "<F13>H",
            function()
                Snacks.notifier.hide()
            end,
            desc = "Dismiss All Notifications",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<F13>ts")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<F13>tw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<F13>tL")
                Snacks.toggle.diagnostics():map("<F13>td")
                Snacks.toggle.line_number():map("<F13>tl")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<F13>tc")
                Snacks.toggle.treesitter():map("<F13>tT")
                Snacks.toggle.inlay_hints():map("<F13>th")
            end,
        })
    end,
}
