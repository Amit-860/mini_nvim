local calendar = require("local.calendar")
local dashboard_opts = {
    enabled = true,
    width = 64,
    pane_gap = 8,
    preset = {
        keys = {

            {
                icon = "  ",
                key = "N",
                desc = "New File",
                action = function()
                    vim.cmd("enew")
                end,
            },
            {
                icon = "󱋢  ",
                desc = "Recent Files",
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
                icon = "  ",
                desc = "Last session",
                key = "L",
                action = function()
                    require("persistence").load({ last = true })
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
            -- {
            --     icon = '  ',
            --     desc = 'NeoGit' ,
            --     key = 'G',
            -- },
            -- {
            --     icon = '󰿅  ',
            --     desc = 'Quit' ,
            --     action = function() vim.cmd("q") end
            -- },
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
        },
        header = calendar.createOutput(),
    },
    formats = {
        header = { "%s", align = "left" },
        footer = { "%s", align = "left" },
    },
    sections = {
        { section = "header" },
        { section = "keys", gap = 0, padding = 2 },
        { pane = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 2 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 3, padding = 2 },
        {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
                return Snacks.git.get_root() ~= nil
            end,
            cmd = "git --no-pager diff --stat -B -M -C",
            height = 5,
            padding = 2,
            ttl = 5 * 60,
            indent = 3,
        },
        { section = "startup" },
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
            -- your scratch configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
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
        },
        lazygit = {
            enabled = true,
            -- your lazygit configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
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
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>tus")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tuw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tuL")
                Snacks.toggle.diagnostics():map("<leader>tud")
                Snacks.toggle.line_number():map("<leader>tul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>tuc")
                Snacks.toggle.treesitter():map("<leader>tuT")
                Snacks.toggle.inlay_hints():map("<leader>tuh")
            end,
        })
    end,
}
