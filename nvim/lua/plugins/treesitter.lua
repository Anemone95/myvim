local load_textobjects = false
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        priority = 1000,
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                init = function()
                    -- disable rtp plugin, as we only need its queries for mini.ai
                    -- In case other textobject modules are enabled, we will load them
                    -- once nvim-treesitter is loaded
                    require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                    load_textobjects = true
                end,
            },
        },
        cmd = { "TSUpdateSync" },
        keys = {
            { "vv",   desc = "Increment selection" },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        ---@type TSConfig
        opts = {
            ignore_install = {}, -- 如果某个解析器有问题,添加到这里
            ensure_installed = {
                "arduino",
                -- "agda",
                "bibtex",
                "bash",
                "c",
                "cmake",
                "comment",
                "cpp",
                "diff",
                "dot",
                "fish",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "graphql",
                "groovy",
                "html",
                "http",
                "htmldjango",
                "javascript",
                "java",
                "jsonc",
                "json",
                "json5",
                "lua",
                "luadoc",
                "luap",
                "latex",
                "make",
                "markdown",
                "markdown_inline",
                "ocaml",
                "ocaml_interface",
                "passwd",
                "python",
                "php",
                "query",
                "ql",
                "regex",
                "rust",
                "tsx",
                "typescript",
                "vue",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "vv",
                    node_incremental = "vv",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            -- Enable treesitter highlighting
            if opts.highlight and opts.highlight.enable then
                vim.api.nvim_create_autocmd("FileType", {
                    callback = function()
                        pcall(vim.treesitter.start)
                    end,
                })
            end

            -- Enable treesitter-based indentation
            if opts.indent and opts.indent.enable then
                vim.api.nvim_create_autocmd("FileType", {
                    callback = function()
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter.indent'.get_indent()"
                    end,
                })
            end

            -- Setup incremental selection
            if opts.incremental_selection and opts.incremental_selection.enable then
                local keymaps = opts.incremental_selection.keymaps
                if keymaps.init_selection then
                    vim.keymap.set('n', keymaps.init_selection, function()
                        require('nvim-treesitter.incremental_selection').init_selection()
                    end)
                end
                if keymaps.node_incremental then
                    vim.keymap.set('x', keymaps.node_incremental, function()
                        require('nvim-treesitter.incremental_selection').node_incremental()
                    end)
                end
                if keymaps.node_decremental then
                    vim.keymap.set('x', keymaps.node_decremental, function()
                        require('nvim-treesitter.incremental_selection').node_decremental()
                    end)
                end
            end

            if load_textobjects then
                -- PERF: no need to load the plugin, if we only need its queries for mini.ai
                if opts.textobjects then
                    for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                        if opts.textobjects[mod] and opts.textobjects[mod].enable then
                            local Loader = require("lazy.core.loader")
                            Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
                            local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
                            require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
                            break
                        end
                    end
                end
            end

            -- Setup treesitter-based folding
            vim.opt.foldlevel = 200
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    vim.wo[0][0].foldmethod = 'expr'
                    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                end,
            })
            -- vim.opt.foldenable = false
        end,
    },
}
