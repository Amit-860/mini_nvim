local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'CmpItemKindClass' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'CmpItemKindValue' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'CmpItemKindMethod' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'CmpItemKindText' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})
