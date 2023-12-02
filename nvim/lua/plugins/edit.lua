local ignore = {
    buftype = { "quickfix", "nofile", "help", 'neo-tree', "neo-tree-popup", "notify", "fidget", "terminal", "prompt" },
    filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", 'terminal', "quickfix", "Trouble", "qf", "Outline",
        "toggleterm", "prompt" },
}
return {
    -- 输入成对括号
    {
        "windwp/nvim-autopairs",
        opts = {
            enable_check_bracket_line = false,
        },
    },
    -- 打开文件时光标恢复原先的位置
    {
        "ethanholz/nvim-lastplace",
        config = true,
    },
    -- 按s 后跳转到单词
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
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
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    -- 驼峰命名法的拼写检查
    {
        "kamykn/spelunker.vim",
        config = function()
            vim.g.spelunker_check_type = 2
        end
    },
    -- 输入 glow 命令渲染 markdown
    {
        "ellisonleao/glow.nvim",
        config = true,
    },
    -- 目录树
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({
                toggler = {
                    ---Line-comment toggle keymap
                    line = '\\ci',
                    ---Block-comment toggle keymap
                    block = '\\ci',
                },
                ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                opleader = {
                    ---Line-comment keymap
                    line = '\\ci',
                    ---Block-comment keymap
                    block = '\\cb',
                },
            })
        end
    },
    -- {
    -- 'echasnovski/mini.ai',
    -- config = true,
    -- },
    {
        "ethanholz/nvim-lastplace",
        config = function()
            require 'nvim-lastplace'.setup {
                lastplace_ignore_buftype = ignore.buftype,
                lastplace_ignore_filetype = ignore.filetype,
                lastplace_open_folds = true
            }
        end
    },
    {
        "s1n7ax/nvim-window-picker",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = true,
                    bo = {
                        filetype = ignore.buftype,
                        buftype = ignore.filetype,
                    }
                }
            })
            vim.keymap.set("n",
                "<c-w>p",
                function()
                    local window_number = require('window-picker').pick_window()
                    if window_number then vim.api.nvim_set_current_win(window_number) end
                end
            )
        end
    }
}
