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
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set({ "n", "v" }, "<F2>", [[<cmd>Neotree toggle<CR>]])
            require("neo-tree").setup({
                window = {
                    position = "left",
                    width = 35,
                },
                open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
                sources = { "filesystem", "buffers", "git_status", "document_symbols" },
                filesystem = {
                    bind_to_cwd = false,
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "", -- or , but this is redundant info if you use git_status_colors on the name
                            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted   = "✖", -- this can only be used in the git_status source
                            renamed   = "󰁕", -- this can only be used in the git_status source
                            -- Status type
                            untracked = "",
                            ignored   = "",
                            unstaged  = "✚",
                            staged    = "",
                            conflict  = "",
                        }
                    },
                }
            })
        end
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({
                toggler = {
                    ---Line-comment toggle keymap
                    line = '\\ci',
                    ---Block-comment toggle keymap
                    block = '\\cb',
                },
                ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                opleader = {
                    ---Line-comment keymap
                    line = 'ci',
                    ---Block-comment keymap
                    block = 'cb',
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
    },
    -- 末尾去空格
    -- {
    --     'Anemone95/whitespace.nvim',
    --     event = "VeryLazy",
    --     config = function()
    --         require('whitespace-nvim').setup({
    --             -- configuration options and their defaults
    --
    --             -- `highlight` configures which highlight is used to display
    --             -- trailing whitespace
    --             highlight = 'DiffDelete',
    --
    --             -- `ignored_filetypes` configures which filetypes to ignore when
    --             -- displaying trailing whitespace
    --             ignored_filetypes = ignore.filetype,
    --             ignored_buffertypes =ignore.buftype,
    --         })
    --
    --         -- remove trailing whitespace with a keybinding
    --         vim.keymap.set('n', '<Leader>w', require('whitespace-nvim').trim)
    --     end
    -- }
}
