local function tex_root(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == "" then
        return nil
    end

    local max_lines = math.min(vim.api.nvim_buf_line_count(bufnr), 20)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)
    local base_dir = vim.fn.fnamemodify(file, ":p:h")

    for _, line in ipairs(lines) do
        local root = line:match("^%%%s*!TEX%s+root%s*=%s*(.-)%s*$")
        if root and root ~= "" then
            if root:sub(1, 1) == "/" or root:sub(1, 1) == "~" then
                return vim.fn.fnamemodify(root, ":p")
            end
            return vim.fn.fnamemodify(base_dir .. "/" .. root, ":p")
        end
    end

    return vim.fn.fnamemodify(file, ":p")
end

return {
    {
        "let-def/texpresso.vim",
        config = function()
            local texpresso = require("texpresso")
            local configured_path = vim.env.TEXPRESSO_PATH

            if configured_path and configured_path ~= "" then
                texpresso.texpresso_path = configured_path
            else
                local exepath = vim.fn.exepath("texpresso")
                if exepath ~= "" then
                    texpresso.texpresso_path = exepath
                end
            end

            vim.api.nvim_create_user_command("TeXpressoRoot", function()
                local root = tex_root(0)
                if not root then
                    vim.notify("No TeX buffer is active", vim.log.levels.WARN)
                    return
                end
                vim.cmd("TeXpresso " .. vim.fn.fnameescape(root))
            end, { desc = "Launch TeXpresso for the current TeX root file" })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "tex",
                callback = function(event)
                    local map = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, {
                            buffer = event.buf,
                            silent = true,
                            desc = desc,
                        })
                    end

                    map("<leader>tv", "<cmd>TeXpressoRoot<CR>", "TeXpresso launch root file")
                    map("<leader>ts", texpresso.synctex_forward, "TeXpresso SyncTeX forward")
                    map("<leader>tn", texpresso.next_page, "TeXpresso next page")
                    map("<leader>tp", texpresso.previous_page, "TeXpresso previous page")
                    map("<leader>tq", "<cmd>copen<CR>", "Open TeXpresso quickfix")
                end,
            })
        end,
    },
}
