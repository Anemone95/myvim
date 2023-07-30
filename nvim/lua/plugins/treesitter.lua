local load_textobjects = false
return {
    {
        "nvim-treesitter/nvim-treesitter",
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
            ensure_installed = {
                "arduino",
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
            if type(opts.ensure_installed) == "table" then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)

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
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldenable = false
        end,
    },
}
