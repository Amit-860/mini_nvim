local utils = require('utils')

-- settings for neovim
if not vim.g.vscode then
    -- explorer
    vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>",
        { noremap = true, silent = true, desc = 'Explorer' })


    -- list buffers
    vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers theme=dropdown<cr>",
        { noremap = true, silent = true, desc = 'which_key_ignore' })


    -- find
    -- vim.keymap.set("n", "<leader>f", "<nop>", { desc = "+Find", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>ff", utils.smart_find_file,
        { noremap = true, silent = true, desc = 'Find Git File' })
    vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files<cr>",
        { noremap = true, silent = true, desc = 'All File' })
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",
        { noremap = true, silent = true, desc = 'String' })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",
        { noremap = true, silent = true, desc = 'Recent Files' })

    -- close Buffer
    vim.keymap.set("n", "<leader>c", "<cmd>bd<cr>", { noremap = true, silent = true, desc = 'Close Buffer' })


    -- session
    -- vim.keymap.set("n", "<leader>S", "<nop>", { desc = "+Session", noremap = true })
    vim.keymap.set("n", "<leader>Ss", "<cmd>lua MiniSessions.select()<cr>",
        { noremap = true, silent = true, desc = 'Switch Session' })
    vim.keymap.set("n", "<leader>Sm", "<cmd>lua MiniSessions.write('Home.vim',{force=true})<cr>",
        { noremap = true, silent = true, desc = 'Make Session' })


    -- Undo
    vim.keymap.set({ "n" }, "<leader>u",
        "<cmd>:lua require('telescope').extensions.undo.undo({ side_by_side = true })<CR>",
        { desc = "Undo", noremap = true })


    -- Quit
    -- vim.keymap.set("n", "<leader>q", "<nop>", { desc = "+Quit", noremap = true })
    vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>", { noremap = true, silent = true, desc = "Quit", })
    vim.keymap.set('n', "<leader>qw", ":wq<cr>", { noremap = true, silent = true, desc = 'Write & Exit' })
    vim.keymap.set('n', "<leader>qQ", ":q!<cr>", { noremap = true, silent = true, desc = 'Force Exit' })
    vim.keymap.set('n', "<C-q>", ":q<cr>", { noremap = true, silent = true, desc = 'Exit' })
    vim.keymap.set('n', "<C-Q>", ":q!<cr>", { noremap = true, silent = true, desc = 'Force Exit' })


    -- tab
    vim.keymap.set('n', "<M-q>", ":tabclose<cr>", { noremap = true, silent = true, desc = 'Tab close' })
    vim.keymap.set('n', "<M-n>", ":tabnew<cr>", { noremap = true, silent = true, desc = 'Tab new' })
    vim.keymap.set('n', "<M-l>", ":tabnext<cr>", { noremap = true, silent = true, desc = 'Tab next' })
    vim.keymap.set('n', "<M-h>", ":tabprevious<cr>", { noremap = true, silent = true, desc = 'Tab prev' })

    -- LeetCode
    -- vim.keymap.set('n', "<leader>L", "<nop>", { noremap = true, silent = true, desc = '+LeetCode' })
    vim.keymap.set('n', "<leader>Lt", ":Leet test<cr>", { noremap = true, silent = true, desc = 'Test' })
    vim.keymap.set('n', "<leader>Ls", ":Leet submit<cr>", { noremap = true, silent = true, desc = 'Submit' })


    -- Home
    vim.keymap.set('n', "<leader>.", ":lua MiniStarter.open()<cr>",
        { noremap = true, silent = true, desc = 'which_key_ignore' })


    -- Code Runner
    -- vim.keymap.set("n", "<leader>r", "<nop>", { desc = "+Run", noremap = true })
    vim.keymap.set("n", "<leader>rf", "<cmd>RunFile<CR>", { noremap = true, silent = true, desc = "Run File", })
    vim.keymap.set("n", "<leader>rc", "<cmd>RunCode<CR>", { noremap = true, silent = true, desc = "Run Code", })


    --lazy
    -- vim.keymap.set("n", "<leader>P", "<nop>", { desc = "+Plugins Mgr", noremap = true })
    vim.keymap.set("n", "<leader>Pi", "<cmd>Lazy install<CR>", { noremap = true, silent = true, desc = "Install", })
    vim.keymap.set("n", "<leader>Ps", "<cmd>Lazy sync<CR>", { noremap = true, silent = true, desc = "Sync", })
    vim.keymap.set("n", "<leader>Pc", "<cmd>Lazy clean<CR>", { noremap = true, silent = true, desc = "Clean", })
    vim.keymap.set("n", "<leader>Pm", "<cmd>Lazy<CR>", { noremap = true, silent = true, desc = "Manager", })

    -- lsp keymap
    -- are in ./pluginSetups/lspConfig.lua

    -- DAP keymappings
    vim.keymap.set("n", "<F5>", function() require('dap').continue() end,
        { desc = "Continue", noremap = true, silent = true })
    vim.keymap.set("n", "<F9>", function() require('dap').toggle_breakpoint() end,
        { desc = "Breakpoints", noremap = true, silent = true })
    vim.keymap.set("n", "<F11>", function() require('dap').step_into() end,
        { desc = "Step Into", noremap = true, silent = true })
    vim.keymap.set("n", "<S-F11>", function() require('dap').step_out() end,
        { desc = "Step Out", noremap = true, silent = true })
    vim.keymap.set("n", "<F10>", function() require('dap').step_over() end,
        { desc = "Step Over", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Dt", function() require('dap').terminate() end,
        { desc = "Terminate", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Dr", function() require('dap').restart() end,
        { desc = "Restart", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Dc", function() require('dap').clear_breakpoints() end,
        { desc = "Clear Breakpoints", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Dl", function() require('dap').list_breakpoints() end,
        { desc = "List Breakpoints", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Du", function() require('dap').up() end,
        { desc = "Up", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Dd", function() require('dap').down() end,
        { desc = "Down", noremap = true, silent = true })

    -- zoxide
    vim.keymap.set("n", "<leader>z", utils.zoxide,
        { desc = "Zoxide", noremap = true, silent = true })

    -- Find and Replace
    vim.keymap.set("n", "<leader>x", utils.find_and_replace,
        { desc = "Replace", noremap = true, silent = true })

    -- help
    vim.keymap.set("n", "<leader>?k", ":Telescope keymaps<cr>",
        { desc = "Search Keymaps", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>?c", ":Telescope commands<cr>",
        { desc = "Search Commands", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>?h", ":Telescope help_tags<cr>",
        { desc = "Search Docs", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>?t", ":Telescope colorscheme<cr>",
        { desc = "Preview Theme", noremap = true, silent = true })

    -- Project
    vim.keymap.set("n", "<leader>p",
        function()
            require 'telescope'.extensions.project.project { display_type = 'full' }
        end,
        { desc = "Projects", noremap = true, silent = true })
end

-- general
vim.keymap.set("v", "<BS>", '"_d')
vim.keymap.set('n', 'U', '<C-r>')
vim.keymap.set('n', '<leader>h', "<cmd>noh<cr>", { desc = "which_key_ignore", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "gs", '_',
    { noremap = true, silent = true, desc = "Goto first Non-whitespace char" })
vim.keymap.set({ "n", "o", "x" }, "gh", '0', { noremap = true, silent = true, desc = "Goto BOL" })
vim.keymap.set({ "n", "o", "x" }, "gl", '$', { noremap = true, silent = true, desc = "Goto EOL" })
vim.keymap.set({ 'n', 'i', 'v' }, "<c-s>", "<esc>:w!<cr>", { noremap = true, silent = true, desc = 'Save' })


-- Treesitter
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
vim.keymap.set({ "n" }, "<M-.>", "<cmd>lua require('ts-node-action').node_action()<cr>",
    { desc = "Trigger Node Action" })


-- Spider
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>",
    { desc = "Spider-w", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>",
    { desc = "Spider-e", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>",
    { desc = "Spider-b", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>",
    { desc = "Spider-ge", noremap = true })
