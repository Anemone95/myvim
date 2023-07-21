vim.cmd('source ~/.vimrc.base')
-- 允许关闭文件后 undo
vim.opt.undofile = true
vim.opt.undodir = '/tmp/nvim/undo'
-- 允许在项目文件夹添加.nvim.lua
vim.opt.exrc = true

-- 允许 options map
vim.g.neovide_input_macos_alt_is_meta = true
vim.keymap.set("n", "bn", "<cmd>bNext<CR>")
vim.keymap.set("n", "bp", "<cmd>bprevious<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
-- 导入数学符号map
vim.cmd('source ~/.vimrc.unimap')

-- 设置字体
vim.opt.guifont = "Hack:h11:cANSI"

if os.getenv("OS") == "Windows_NT" then
    vim.opt.guifontwide = "YouYuan:h10.5:cGB2312"
elseif os.getenv("HOME") == '/Users' then
    vim.opt.guifont = "Hack:h11:cANSI"
else
    vim.opt.guifontwide="WenQuanYi Micro Hei 11"
end


local is_ssh = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT")
if not is_ssh then
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

