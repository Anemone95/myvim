return {
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
