return {
    {
        "folke/persistence.nvim",
        config = function()
            require("persistence").setup()
            vim.keymap.set("n","<leader>qs", [[<cmd>lua require("persistence").load()<cr>]])
            vim.keymap.set("n","<leader>ql", [[<cmd>lua require("persistence").load({ last = true})<cr>]])
            vim.keymap.set("n","<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]])
        end
    },
    {
        "folke/which-key.nvim",
        config = false,
    },
}
