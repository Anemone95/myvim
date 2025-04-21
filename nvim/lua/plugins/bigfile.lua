return {
    "LunarVim/bigfile.nvim",
    config = function()
        require("bigfile").setup {
            filesize = 1,  -- size of the file in MiB, the plugin round file sizes to the closest MiB
            pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
            features = {   -- features to disable
                "indent_blankline",
                "illuminate",
                "lsp",
                "treesitter",
                "syntax",
                "matchparen",
                "vimopts",
                "filetype",
            },
            pattern = function(bufnr, filesize_mib)
                local line_count = vim.fn.line('$')
                local line_length = vim.fn.line2byte(line_count + 1)
                if line_length > 5000 then
                    return true
                end
                return false
            end

        }
    end
}
