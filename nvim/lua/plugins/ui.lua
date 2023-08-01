local ret = {
    -- 主题
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd [[colorscheme tokyonight-storm]]
        end
    },
    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "utilyre/barbecue.nvim",
            "SmiteshP/nvim-navic",
        },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'tokyonight'
                },
                extensions = { "neo-tree", "lazy" },
            })
            require('barbecue').setup({
                theme = 'tokyonight',
            })
        end
    },
    -- bufferline
    {
        'akinsho/bufferline.nvim',
        event = "VeryLazy",
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = {
            options = {
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' }
                }
            }
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        version = "*",
        config = function()
            vim.cmd [[highlight IndentBlanklineIndent1 guifg=#86bbd8 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guifg=#ebebd3 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent3 guifg=#f4d35e gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent4 guifg=#ee964b gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent5 guifg=#f95738 gui=nocombine]]
            -- vim.opt.list = true
            -- vim.g.indent_blankline_char = "┊"
            char = "│",
                require("indent_blankline").setup({
                    show_trailing_blankline_indent = false,
                    show_current_context = false,
                    -- space_char_blankline = " ",
                    -- char_highlight_list = {
                    -- "IndentBlanklineIndent1",
                    -- "IndentBlanklineIndent2",
                    -- "IndentBlanklineIndent3",
                    -- "IndentBlanklineIndent4",
                    -- "IndentBlanklineIndent5",
                    -- },
                })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = true
    },
    -- 启动界面
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope.nvim', },
        config = function()
            local dashboard = require 'alpha.themes.dashboard'
            dashboard.section.buttons.val = {
                dashboard.button("n", "  New file", "<cmd>ene <CR>"),
                dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
                dashboard.button("r", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("g", "󰊄  Grep files", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("m", "  Jump to bookmarks"),
                dashboard.button("s", "  Open last session"),
                dashboard.button('s', '  Settings', ':e $MYVIMRC<CR>'),
                dashboard.button('u', '  Update plugins', ':Lazy update<CR>'),
                dashboard.button('q', '  Quit', ':qa<CR>'),
            }
            require('alpha').setup(require('alpha.themes.dashboard').config)
        end
    },
    -- 相同字符高亮
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
            require('illuminate').configure({
                -- providers: provider used to get references in the buffer, ordered by priority
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                -- delay: delay in milliseconds
                delay = 100,
                -- filetype_overrides: filetype specific overrides.
                -- The keys are strings to represent the filetype while the values are tables that
                -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
                filetype_overrides = {},
                -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
                filetypes_denylist = {
                    'dirvish',
                    'fugitive',
                    'alpha',
                },
                -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
                filetypes_allowlist = {},
                -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
                -- See `:help mode()` for possible values
                modes_denylist = {},
                -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
                -- See `:help mode()` for possible values
                modes_allowlist = {},
                -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
                -- Only applies to the 'regex' provider
                -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
                providers_regex_syntax_denylist = {},
                -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
                -- Only applies to the 'regex' provider
                -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
                providers_regex_syntax_allowlist = {},
                -- under_cursor: whether or not to illuminate under the cursor
                under_cursor = true,
                -- large_file_cutoff: number of lines at which to use large_file_config
                -- The `under_cursor` option is disabled when this cutoff is hit
                large_file_cutoff = nil,
                -- large_file_config: config to use for large files (based on large_file_cutoff).
                -- Supports the same keys passed to .configure
                -- If nil, vim-illuminate will be disabled for large files.
                large_file_overrides = nil,
                -- min_count_to_highlight: minimum number of matches required to perform highlighting
                min_count_to_highlight = 1,
            })
        end
    },
    -- terminal
    {
        'akinsho/toggleterm.nvim',
        event = "VeryLazy",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 10,
                close_on_exit = true,
                open_mapping = "<c-\\>",
            })
            vim.keymap.set({ "n", "t" }, "<F3>", "<cmd>ToggleTerm<CR>", { desc = { "toggle terminal" } })
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<c-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<c-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<c-l>', [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set('t', '<c-w>', [[<C-\><C-n><C-w>]], opts)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end
    },
}

if vim.g.neovide then
    table.insert(ret,
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {
                lsp = {
                    progress = {
                        enabled = true,
                        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                        -- See the section on formatting for more details on how to customize.
                        --- @type NoiceFormat|string
                        format = "lsp_progress",
                        --- @type NoiceFormat|string
                        format_done = "lsp_progress_done",
                        throttle = 1000 / 30, -- frequency to update lsp progress message
                        view = "mini",
                    },
                    override = {
                        -- override the default lsp markdown formatter with Noice
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                        -- override the lsp markdown formatter with Noice
                        ["vim.lsp.util.stylize_markdown"] = false,
                        -- override cmp documentation with Noice (needs the other options to work)
                        ["cmp.entry.get_documentation"] = false,
                    },
                    hover = {
                        enabled = true,
                        silent = false, -- set to true to not show a message if hover is not available
                        view = nil, -- when nil, use defaults from documentation
                        ---@type NoiceViewOptions
                        opts = {}, -- merged with defaults from documentation
                    },
                    signature = {
                        enabled = true,
                        auto_open = {
                            enabled = true,
                            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                            throttle = 50, -- Debounce lsp signature help request by 50ms
                        },
                        view = nil, -- when nil, use defaults from documentation
                        ---@type NoiceViewOptions
                        opts = {}, -- merged with defaults from documentation
                    },
                    message = {
                        -- Messages shown by lsp servers
                        enabled = true,
                        view = "notify",
                        opts = {},
                    },
                    -- defaults for hover and signature help
                    documentation = {
                        view = "hover",
                        ---@type NoiceViewOptions
                        opts = {
                            lang = "markdown",
                            replace = true,
                            render = "plain",
                            format = { "{message}" },
                            win_options = { concealcursor = "n", conceallevel = 3 },
                        },
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            any = {
                                { find = "%d+L, %d+B" },
                                { find = "; after #%d+" },
                                { find = "; before #%d+" },
                            },
                        },
                        view = "mini",
                    },
                },
            },
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
            }
        }
    )
end


return ret;
