return {
    "nvimtools/none-ls.nvim",  -- Community fork of null-ls.nvim (maintained)
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "jay-babu/mason-null-ls.nvim"
    },
    config = function()
        local tools = {
            "black",
        }
        require("mason-null-ls").setup({
            ensure_installed = tools,
            handlers = {},
        })
        require("null-ls").setup({
            sources = {},
        })
    end
}
