local M = {}
M.toggle_term_opts = {
    active = true,
    on_config_done = nil,
    -- size can be a number or function which is passed the current terminal
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
    direction = "float",
    close_on_exit = true, -- close the terminal window when the process exits
    shell = nil,          -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        border = "single",
        width = function()
            return math.ceil(vim.o.columns * 0.84)
        end,
        height = function()
            return math.ceil(vim.o.lines * 0.80)
        end,
        winblend = 0,
        highlights = {
            border = "FloatBorder",
            background = "NormalFloat",
        },
    },
    execs = {
        { nil, "<M-1>", "Horizontal Terminal", "horizontal", 0.3 },
        { nil, "<M-2>", "Vertical Terminal",   "vertical",   0.4 },
        { nil, "<M-3>", "Float Terminal",      "float",      nil },
    },
}

if vim.g.neovide then
    M.toggle_term_opts.float_opts.winblend = 70
    M.toggle_term_opts.float_opts.border = "none"
end

local function get_buf_size()
    local cbuf = vim.api.nvim_get_current_buf()
    local bufinfo = vim.tbl_filter(function(buf)
        return buf.bufnr == cbuf
    end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
    if bufinfo == nil then
        return { width = -1, height = -1 }
    end
    return { width = bufinfo.width, height = bufinfo.height }
end

local function get_dynamic_terminal_size(direction, size)
    size = size or M.toggle_term_opts.size
    if direction ~= "float" and tostring(size):find(".", 1, true) then
        size = math.min(size, 1.0)
        local buf_sizes = get_buf_size()
        local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
        return buf_size * size
    else
        return size
    end
end

M.init = function()
    local terminal = require "toggleterm"
    terminal.setup(M.toggle_term_opts)
    for i, exec in pairs(M.toggle_term_opts.execs) do
        local direction = exec[4] or M.toggle_term_opts.direction

        local opts = {
            cmd = exec[1] or M.toggle_term_optsshell or vim.o.shell,
            keymap = exec[2],
            label = exec[3],
            -- NOTE: unable to consistently bind id/count <= 9, see #2146
            count = i + 100,
            direction = direction,
            size = function()
                return get_dynamic_terminal_size(direction, exec[5])
            end,
        }
        M.add_exec(opts)
    end
end

M.add_exec = function(opts)
    local binary = opts.cmd:match "(%S+)"
    if vim.fn.executable(binary) ~= 1 then
        return
    end

    vim.keymap.set({ "n", "t" }, opts.keymap, function()
        M._exec_toggle { cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() }
    end, { desc = opts.label, noremap = true, silent = true })
end

M._exec_toggle = function(opts)
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
    term:toggle(opts.size, opts.direction)
end

M.lazygit_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float_opts = {
        border = "none",
        height = math.floor(vim.o.lines * 1),
        width = math.floor(vim.o.columns * 1),
    }
    local lazygit = Terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = 99,
    }
    -- condition for neovide
    if vim.g.neovide then
        float_opts.height = math.floor(vim.o.lines * 0.98)
        float_opts.width = math.floor(vim.o.columns * 0.98)
    end
    lazygit:toggle()
end

M.broot_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float_opts = {
        -- height = math.floor(vim.o.lines * 1),
        -- width = math.floor(vim.o.columns * 1),
    }
    local broot = Terminal:new {
        cmd = "broot",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = 99,
    }
    -- condition for neovide
    if vim.g.neovide then
        -- float_opts.height = math.floor(vim.o.lines * 1.0)
        -- float_opts.width = math.floor(vim.o.columns * 1.0)
    end
    broot:toggle()
end

M.code_runner = function(run_cmd, direction)
    local Terminal = require("toggleterm.terminal").Terminal
    local file_name = vim.api.nvim_buf_get_name(0)
    local py_runner = Terminal:new {
        cmd = run_cmd .. " " .. file_name,
        hidden = true,
        direction = direction,
        close_on_exit = false, -- close the terminal window when the process exits
        -- float_opts = {},
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = 99,
    }
    py_runner:toggle()
end

M.init()

return M
