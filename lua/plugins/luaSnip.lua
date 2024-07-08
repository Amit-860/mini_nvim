return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    event = "BufReadPost",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        require("luasnip").setup()
        require("luasnip.loaders.from_vscode").lazy_load()
    end
}
