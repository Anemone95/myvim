vim.cmd('source ~/.vimrc.base')
-- 允许关闭文件后 undo
vim.opt.undofile = true
vim.opt.undodir = '/tmp/nvim/undo'
-- 允许在项目文件夹添加.nvim.lua
vim.opt.exrc = true

-- Fix for position_encoding warning in Neovim v0.11+
if vim.fn.has('nvim-0.11') == 1 then
    local original_make_position_params = vim.lsp.util.make_position_params
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.make_position_params = function(win, offset_encoding)
        if not offset_encoding then
            local bufnr = vim.api.nvim_win_get_buf(win or 0)
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if clients and clients[1] then
                offset_encoding = clients[1].offset_encoding or 'utf-16'
            else
                offset_encoding = 'utf-16'
            end
        end
        return original_make_position_params(win, offset_encoding)
    end
end

-- 允许 options map
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
vim.keymap.set("n", "bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "bp", "<cmd>bprevious<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "<space>", "@=((foldclosed(line('.')) < 0) ? 'zc' : 'zO')<CR>")
vim.keymap.set("n", "za", "zM")
vim.keymap.set("n", "zo", "zO")


-- Smart sentence navigation for markdown and latex files
local function smart_dollar()
    local ft = vim.bo.filetype
    if ft == "markdown" or ft == "tex" or ft == "latex" then
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col('.')
        local rest_of_line = line:sub(col + 1)

        -- Search for sentence ending punctuation: . , ; ?
        local next_pos = rest_of_line:find('[%.,%?;]')

        if next_pos then
            -- Move to the punctuation mark
            vim.cmd('normal! ' .. next_pos .. 'l')
        else
            -- No punctuation found, go to end of line
            vim.cmd('normal! $')
        end
    else
        vim.cmd('normal! $')
    end
end

local function smart_zero()
    local ft = vim.bo.filetype
    if ft == "markdown" or ft == "tex" or ft == "latex" then
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col('.')
        local before_cursor = line:sub(1, col - 1)

        -- Search backwards for sentence ending punctuation: . , ; ?
        local prev_pos = nil
        for i = #before_cursor, 1, -1 do
            local char = before_cursor:sub(i, i)
            if char == '.' or char == ',' or char == ';' or char == '?' then
                prev_pos = i
                break
            end
        end

        if prev_pos then
            -- Move cursor to the punctuation mark
            vim.api.nvim_win_set_cursor(0, {vim.fn.line('.'), prev_pos - 1})
        else
            -- No punctuation found, go to beginning of line
            vim.cmd('normal! 0')
        end
    else
        vim.cmd('normal! 0')
    end
end

vim.keymap.set({"n", "v", "x"}, "0", smart_zero, { noremap = true, silent = true })
vim.keymap.set({"n", "v", "x"}, "$", smart_dollar, { noremap = true, silent = true })

-- 导入数学符号map
vim.cmd('source ~/.vimrc.unimap')

-- 设置字体
vim.opt.guifont = "Hack:h15"


if os.getenv("OS") == "Windows_NT" then
    vim.opt.guifontwide = "YouYuan:h10.5:cGB2312"
elseif not os.getenv("HOME") == '/Users' then
    vim.opt.guifontwide = "WenQuanYi Micro Hei 11"
end

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.netrw_list_hide = '.*\\~$,\\~$,\\~\\~$'
vim.g.netrw_sort_sequence = '[\\/],$,*'


local function load_lazy()
    -- lazyvim 插件
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--depth=1",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

local is_ssh = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT")
if is_ssh then
    vim.opt.cursorline = false
    vim.o.mouse = ""
elseif vim.g.vscode then
    load_lazy()
    require("lazy").setup("vsplugins")
    -- Ensure lazy.nvim is on the runtimepath when running embedded in VSCode
    -- so subsequent calls to `require('lazy')` succeed.
    local vscode = require('vscode')
    -- using 'open default keyboard shortcuts' to see the command list
    vim.keymap.set({ "n" }, "mm", function () vscode.action("bookmarks.toggle") end , { noremap = true })
    vim.keymap.set({ "n" }, "mp", function () vscode.action("bookmarks.jumpToPrevious") end, { noremap = true })
    vim.keymap.set({ "n" }, "mn", function () vscode.action("bookmarks.jumpToNext") end, { noremap = true })

    vim.keymap.set({ "n"}, "<F9>", function () vscode.action("workbench.action.tasks.runTask") end )
    vim.keymap.set({ "n"}, "<F10>", function () vscode.action("workbench.action.debug.start") end)

    vim.keymap.set({ "n" }, "bn", "<Cmd>Tabnext<CR>", { noremap = true })
    vim.keymap.set({ "n" }, "bp", "<Cmd>Tabprevious<CR>", { noremap = true })

    vim.keymap.set({ "n" }, "<leader>fe", function () vscode.action("workbench.action.findInFiles") end, { noremap = true })
    vim.keymap.set({ "n" }, "fe", function() vscode.action("workbench.action.findInFiles") end, { noremap = true })

    vim.keymap.set({'n'}, '<leader>c', function() vscode.action("keybindings.editor.clearSearchResults") end, { noremap = true })
    vim.keymap.set({ "n" }, "<leader>ff", function ()
        vscode.action("keybindings.editor.clearSearchResults")
        vscode.action("workbench.action.showAllSymbols")
    end, { noremap = true })
    vim.keymap.set({ "n" }, "fe", function() vscode.action("workbench.action.findInFiles") end, { noremap = true })
    
    vim.keymap.set({ "n" }, "<leader>fr", function () vscode.action("workbench.action.openRecent") end, { noremap = true })
    vim.keymap.set({ "n" }, "fr", function() vscode.action("workbench.action.openRecent") end, { noremap = true })

    vim.keymap.set({ "n" }, "<space>", function() vscode.action("editor.toggleFold") end, { noremap = true })
    vim.keymap.set({ "n" }, "zo", function() vscode.action("editor.unfold") end, { noremap = true })
    vim.keymap.set({ "n" }, "zz", function() vscode.action("editor.fold") end, { noremap = true })
    vim.keymap.set({ "n" }, "za", function() vscode.action("editor.foldAll") end, { noremap = true })

    vim.keymap.set({'n'}, '=', function() vscode.action("editor.action.formatDocument") end, { noremap = true })

    vim.keymap.set({'n','i','v'}, '<leader>ci', function() vscode.action("editor.action.commentLine") end, { noremap = true })
    -- TODO 多行编辑

    vim.keymap.set({ "n", "x" }, "<leader>rn", function()
        vscode.with_insert(function()
            vscode.action("editor.action.rename")
        end)
    end)

    vim.keymap.set({'n'}, 'gi', function() vscode.action("editor.action.goToImplementation") end, { noremap = true })
    vim.keymap.set({'n'}, 'go', function() vscode.action("workbench.action.navigateBack") end, { noremap = true })
    vim.keymap.set({'n'}, 'gd', function() vscode.action("editor.action.revealDefinition") end, { noremap = true })
    vim.keymap.set({'n'}, 'gp', function() vscode.action("workbench.action.navigateToLastEditLocation") end, { noremap = true })
    vim.keymap.set({'n'}, 'gn', function() vscode.action("workbench.action.navigateForwardInEditLocations") end, { noremap = true })
    vim.keymap.set({'n'}, 'gq', function() vscode.action("editor.action.marker.nextInFiles") end, { noremap = true })
    -- vim.keymap.set({'n','x'}, '<Right>', function() vscode.action("workbench.action.navigateRight") end, { noremap = true })
    -- vim.keymap.set({'n','x'}, '<Left>', function() vscode.action("workbench.action.navigateLeft") end, { noremap = true })
    -- vim.keymap.set({'n','x'}, '<Up>', function() vscode.action("workbench.action.navigateUp") end, { noremap = true })
    -- vim.keymap.set({'n','x'}, '<Down>', function() vscode.action("workbench.action.navigateDown") end, { noremap = true })
    vim.keymap.set({'v'}, 'v', function() vscode.action("editor.action.smartSelect.expand") end, { noremap = true })
    -- config in vscode might be better?
    vim.keymap.set({'n'}, '<F9>', function() vscode.action("workbench.action.debug.run") end, { noremap = true })
    vim.keymap.set({'n'}, '<F10>', function() vscode.action("workbench.action.debug.start") end, { noremap = true })
    vim.keymap.set({'n'}, '<F2>', function() vscode.action("workbench.action.toggleSidebarVisibility") vscode.action("workbench.view.explorer") end, { noremap = true })
    vim.keymap.set({'n'}, '<F3>', function() vscode.action("workbench.action.terminal.toggleTerminal") end, { noremap = true })
    vim.keymap.set({'n'}, '<F4>', function() vscode.action("workbench.files.action.showActiveFileInExplorer") end, { noremap = true })

    local opts = { desc = "Move by display line", silent = true, remap = true }
    vim.keymap.set({ "n", "v", "x" }, "j", "gj", opts)
    vim.keymap.set({ "n", "v", "x" }, "k", "gk", opts)
else
    load_lazy()
    local opts = {
        install = {
            -- try to load one of these colorschemes when starting an installation during startup
            colorscheme = { "tokyonight-storm" },
        },
    }
    require("lazy").setup("plugins", opts)
    local opts = { desc = "Move by display line", silent = true, noremap = true }
    vim.keymap.set({ "n", "v", "x" }, "j", "gj", opts)
    vim.keymap.set({ "n", "v", "x" }, "k", "gk", opts)
end


if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
end

vim.keymap.set('c', '<D-v>', '<C-r>+', { noremap = true })
vim.keymap.set('i', '<D-v>', '<Cmd>put +<CR>', {})
