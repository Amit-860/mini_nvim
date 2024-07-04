local icons = require('icons')
local colors = {
    grey        = '#a0a1a7',
    light_green = '#83a598',
    black       = "#2F3239",
    red         = "#c54e45",
    green       = "#688b89",
    yellow      = "#fda47f",
    blue        = "#5a93aa",
    magenta     = "#ad5c7c",
    cyan        = "#afd4de",
    white       = "#ebebeb",
    orange      = "#fda47f",
    pink        = "#cb7985",

    bg0         = "#0b1416", -- Dark bg (status line and float)
    bg1         = "#101e21", -- Default bg
    bg2         = "#1d3337", -- Lighter bg (colorcolm folds)
    bg3         = "#254147", -- Lighter bg (cursor line)
    bg4         = "#2d4f56", -- Conceal, border fg
    fg0         = "#eaeeee", -- Lighter fg
    fg1         = "#e6eaea", -- Default fg
    fg2         = "#cbd9d8", -- Darker fg (status line)
    fg3         = "#587b7b", -- Darker fg (line numbers, fold colums)
    sel0        = "#293e40", -- Popup bg, visual selection bg
    sel1        = "#425e5e", -- Popup sel bg, search bg
}

local theme = {
    normal = {
        a = { fg = colors.white, bg = colors.bg1, bold = true },
        b = { fg = colors.white, bg = colors.bg2, },
        c = { fg = colors.black, bg = colors.bg0, },
        z = { fg = colors.white, bg = colors.bg1 },
    },
    insert = { a = { fg = colors.black, bg = colors.green, bold = true } },
    visual = { a = { fg = colors.black, bg = colors.yellow, bold = true } },
    replace = { a = { fg = colors.black, bg = colors.red, bold = true } },
    command = { a = { fg = colors.black, bg = colors.blue, bold = true } },
}


local window_width_limit = 100
local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
        return vim.o.columns > window_width_limit
    end,
    -- check_git_workspace = function()
    --   local filepath = vim.fn.expand "%:p:h"
    --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
    --   return gitdir and #gitdir > 0 and #gitdir < #filepath
    -- end,
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
    self.status = ''
    self.applied_separator = ''
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < 'x'
        for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
            table.insert(section, pos * 2, { empty, color = { fg = colors.bg0, bg = colors.bg0 } })
            -- table.insert(section, pos * 2, { empty, })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= 'table' then
                comp = { comp }
                section[id] = comp
            end
            comp.separator = left and { right = '' } or { left = '' }
        end
    end
    return sections
end

local function search_result()
    if vim.v.hlsearch == 0 then
        return ''
    end
    local last_search = vim.fn.getreg('/')
    if not last_search or last_search == '' then
        return ''
    end
    local searchcount = vim.fn.searchcount { maxcount = 9999 }
    return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
    if vim.bo.modified then
        return '+'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return '-'
    end
    return ''
end

local noice = require("noice")
local macro = {
    function()
        if noice.api.statusline.mode.has then
            return noice.api.statusline.mode.get() or ""
        else
            return ""
        end
    end,
    color = { gui = "bold" },
}

local lsp = {
    function()
        local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #buf_clients == 0 then
            return "LSP Inactive"
        end

        local buf_client_names = {}
        -- add client
        for _, client in pairs(buf_clients) do
            if client.name ~= "null-ls" and client.name ~= "copilot" then
                table.insert(buf_client_names, client.name)
            end
        end
        local unique_client_names = vim.fn.uniq(buf_client_names)
        local language_servers = table.concat(unique_client_names, ", ")
        return language_servers
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
}

require('lualine').setup {
    options = {
        theme = theme,
        -- theme = 'auto',
        component_separators = { left = "", right = "" },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { "alpha" },
    },
    sections = process_sections {
        lualine_a = {
            { 'mode', color = { gui = "bold" } },
            macro
        },
        lualine_b = {
            {
                "b:gitsigns_head",
                icon = icons.git.Branch,
                color = { gui = "bold" },
            },
            { 'diff',     color = { gui = "bold" } },
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'error' },
                diagnostics_color = { error = { bg = colors.red, fg = colors.black } },
                color = { gui = "bold" },
            },
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'warn' },
                diagnostics_color = { warn = { bg = colors.orange, fg = colors.black } },
                color = { gui = "bold" },
            },
            { 'filename', file_status = false,                                   path = 1 },
            { modified,   color = { bg = colors.light_green, fg = colors.black } },
            {
                '%w',
                cond = function()
                    return vim.wo.previewwindow
                end,
            },
            {
                '%r',
                cond = function()
                    return vim.bo.readonly
                end,
            },
            {
                '%q',
                cond = function()
                    return vim.bo.buftype == 'quickfix'
                end,
            },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { search_result, 'filetype', lsp },
        lualine_z = { '%l:%c', '%p%%/%L' },
    },
    inactive_sections = {
        lualine_c = { '%f %y %m' },
        lualine_x = {},
    },
}
