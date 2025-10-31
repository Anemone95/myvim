return {
    {
        'vscode-neovim/vscode-multi-cursor.nvim',
        event = 'VeryLazy',
        cond = vim.g.vscode,
        config = function()
            require('vscode-multi-cursor').setup {
                -- Enable default mappings: mc, mi, ma, etc.
                default_mappings = true,
                no_selection = false
            }

            local cursor = require('vscode-multi-cursor')

            -- Ctrl+n: 添加下一个相同单词到多光标选择
            vim.keymap.set({ 'n', 'x', 'i' }, '<C-n>', function()
                cursor.addSelectionToNextFindMatch()
            end, { desc = 'Add selection to next find match' })

            -- Ctrl+x: 跳过当前匹配，移动到下一个
            vim.keymap.set({ 'n', 'x', 'i' }, '<C-x>', function()
                require('vscode').action('editor.action.moveSelectionToNextFindMatch')
            end, { desc = 'Skip current and move to next match' })

            -- Ctrl+p: 返回到上一个匹配
            vim.keymap.set({ 'x' }, '<C-p>', function()
                require('vscode').action('editor.action.moveSelectionToPreviousFindMatch')
            end, { desc = 'Move to previous match' })

            -- Ctrl+a: 选择所有匹配项（相当于 Ctrl+Shift+L）
            vim.keymap.set({ 'n', 'x', 'i' }, '<C-a>', function()
                cursor.selectHighlights()
            end, { desc = 'Select all matches' })
        end,
        opts = {},
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        cond = vim.g.vscode,
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<leader>s",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },

}
