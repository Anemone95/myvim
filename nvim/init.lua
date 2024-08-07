vim.cmd('source ~/.vimrc.base')
-- 允许关闭文件后 undo
vim.opt.undofile = true
vim.opt.undodir = '/tmp/nvim/undo'
-- 允许在项目文件夹添加.nvim.lua
vim.opt.exrc = true

-- 允许 options map
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
vim.keymap.set("n", "bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "bp", "<cmd>bprevious<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "<space>", "@=((foldclosed(line('.')) < 0) ? 'zc' : 'zO')<CR>")
vim.keymap.set("n", "za", "zM")
vim.keymap.set("n", "zo", "zO")
-- 导入数学符号map
vim.cmd('source ~/.vimrc.unimap')

-- 设置字体
vim.opt.guifont = "Hack:h15"


if os.getenv("OS") == "Windows_NT" then
    vim.opt.guifontwide = "YouYuan:h10.5:cGB2312"
elseif not os.getenv("HOME") == '/Users' then
    vim.opt.guifontwide = "WenQuanYi Micro Hei 11"
end

-- 设置 netrw
vim.g.netrw_banner = 0        -- 关闭启动时的横幅信息
vim.g.netrw_liststyle = 3     -- 设置文件列表风格，3 为树状视图
vim.g.netrw_browse_split = 4  -- 在新标签页中打开选择的文件
vim.g.netrw_altv = 1          -- 在垂直分割窗口中打开文件
vim.g.netrw_winsize = 20      -- 设置 netrw 窗口的宽度百分比
vim.g.netrw_list_hide = '.*\\~$,\\~$,\\~\\~$'
vim.g.netrw_sort_sequence = '[\\/],$,*'


local is_ssh = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT")
if is_ssh then
    vim.opt.cursorline = false
    vim.o.mouse = ""
else
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
    local opts = {
        install = {
            -- try to load one of these colorschemes when starting an installation during startup
            colorscheme = { "tokyonight-storm" },
        },
    }
    require("lazy").setup("plugins", opts)
end

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
end

-- 粘贴 
vim.keymap.set('c', '<D-v>', '<C-r>+', { noremap = true })
vim.keymap.set('i', '<D-v>', '<Cmd>put +<CR>', {})
