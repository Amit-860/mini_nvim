-- setting for neovide
if vim.g.neovide then
    vim.cmd([[set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
             \,a:blinkwait1000-blinkoff500-blinkon500-Cursor/lCursor]])
    vim.o.guifont = "VictorMono Nerd Font:h10.5"
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 4
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_vfx_mode = "wireframe"
    -- vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_particle_density = 10
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_underline_automatic_scaling = true
    vim.g.neovide_no_idle = false
    vim.g.neovide_cursor_unfocused_outline_width = 0.05
    vim.g.neovide_confirm_quit = true

    vim.g.neovide_transparency = 0.75
    vim.g.neovide_fullscreen = true

    vim.o.winblend = 50
    vim.o.pumblend = 50

    vim.opt.cursorline = false
end


-- settings for neovim
if not vim.g.vscode then
    -- explorer
    vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>",
        { noremap = true, silent = true, desc = 'Explorer' })


    -- list buffers
    vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers theme=dropdown<cr>",
        { noremap = true, silent = true, desc = 'Find Buffer' })


    -- find
    vim.keymap.set("n", "<leader>f", "<nop>", { desc = "+Find", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope git_files<cr>",
        { noremap = true, silent = true, desc = 'Find Git File' })
    vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files<cr>",
        { noremap = true, silent = true, desc = 'Find All File' })
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",
        { noremap = true, silent = true, desc = 'Find String' })

    -- close Buffer
    vim.keymap.set("n", "<leader>c", "<cmd>bd<cr>", { noremap = true, silent = true, desc = 'Close Buffer' })


    -- session
    -- vim.keymap.set("n", "<leader>S", "<nop>", { desc = "+Session", noremap = true })
    vim.keymap.set("n", "<leader>Ss", "<cmd>lua MiniSessions.select()<cr>",
        { noremap = true, silent = true, desc = 'Switch Session' })
    vim.keymap.set("n", "<leader>Sm", "<cmd>lua MiniSessions.write('Home.vim',{force=true})<cr>",
        { noremap = true, silent = true, desc = 'Make Session' })


    -- Telescope
    -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true })
    vim.keymap.set({ "n" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { desc = "Code Action", noremap = true })
    vim.keymap.set({ "n" }, "<leader>lr", "<cmd>Telescope lsp_references theme=get_ivy<CR>",
        { desc = "References", noremap = true })
    vim.keymap.set({ "n" }, "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>",
        { desc = "Rename Symbol", noremap = true })
    vim.keymap.set({ "n" }, "<leader>ld", "<cmd>Telescope lsp_definitions theme=get_ivy<CR>",
        { desc = "Definitions", noremap = true })
    vim.keymap.set({ "n" }, "<leader>li", "<cmd>Telescope lsp_implementations theme=get_ivy<CR>",
        { desc = "Implementations", noremap = true })
    vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Telescope lsp_document_symbols theme=get_ivy<CR>",
        { desc = "Document Symbols", noremap = true })
    vim.keymap.set({ "n" }, "<leader>lD", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<CR>",
        { desc = "Diagnostics", noremap = true })

    -- Undo
    vim.keymap.set({ "n" }, "<leader>z",
        "<cmd>:lua require('telescope').extensions.undo.undo({ side_by_side = true })<CR>",
        { desc = "Undo", noremap = true })


    -- Quit
    -- vim.keymap.set("n", "<leader>q", "<nop>", { desc = "+Quit", noremap = true })
    vim.keymap.set("n", "<leader>qq", "<cmd>q!<cr>", { noremap = true, silent = true, desc = "Quit", })
    vim.keymap.set('n', "<leader>qw", ":wq<cr>", { noremap = true, silent = true, desc = 'Write & Exit' })
    vim.keymap.set('n', "<leader>qQ", ":q!<cr>", { noremap = true, silent = true, desc = 'Force Exit' })
    vim.keymap.set('n', "<C-q>", ":q<cr>", { noremap = true, silent = true, desc = 'Exit' })
    vim.keymap.set('n', "<C-Q>", ":q!<cr>", { noremap = true, silent = true, desc = 'Force Exit' })


    -- LeetCode
    -- vim.keymap.set('n', "<leader>L", "<nop>", { noremap = true, silent = true, desc = '+LeetCode' })
    vim.keymap.set('n', "<leader>Lt", ":Leet test<cr>", { noremap = true, silent = true, desc = 'Test' })
    vim.keymap.set('n', "<leader>Ls", ":Leet submit<cr>", { noremap = true, silent = true, desc = 'Submit' })


    -- Home
    vim.keymap.set('n', "<leader>.", ":lua MiniStarter.open()<cr>", { noremap = true, silent = true, desc = 'Home' })


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

    -- lsp lines
    local lsp_lines_enable = false
    vim.diagnostic.config({ virtual_lines = lsp_lines_enable })
    vim.keymap.set("n", "<leader>lh",
        function()
            vim.diagnostic.config({
                virtual_text = lsp_lines_enable,
                signs = true,
                underline = true,
            })
            vim.diagnostic.config({ virtual_lines = not lsp_lines_enable })
            lsp_lines_enable = not lsp_lines_enable
        end,
        { desc = "Toggle HlChunk", noremap = true }
    )
end


-- general
vim.keymap.set("v", "<BS>", '"_d')
vim.keymap.set('n', 'U', '<C-r>')
vim.keymap.set('n', '<leader>h', "<cmd>noh<cr>", { desc = "NOH", noremap = true })
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
