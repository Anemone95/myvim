return {
    -- {
    --     "ashinkarov/agda.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --
    --     },
    --     config = function ()
    --     end,
    --     -- ft = { 'agda' },
    -- },
    -- {
    --     "derekelkins/agda-vim",
    --     config = function ()
    --     end
    -- }
    {
        'isovector/cornelis',
        dependencies = {
            "neovimhaskell/nvim-hs.vim",
            "kana/vim-textobj-user",
        },
        config = function ()
        end,
        ft = { 'agda' },
        post_hook = 'stack build'
    },
}
