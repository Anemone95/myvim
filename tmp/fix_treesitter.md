# Treesitter 查询错误修复方案

## 方案 1: 更新所有解析器
```bash
nvim
# 在 Neovim 中执行:
:TSUpdate
```

## 方案 2: 清理并重新安装
```bash
# 删除 treesitter 缓存
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
rm -rf ~/.local/state/nvim/treesitter

# 重新打开 Neovim,让 lazy.nvim 重新安装
nvim

# 然后执行:
:Lazy sync
:TSUpdate
```

## 方案 3: 禁用有问题的解析器
如果错误持续出现,可能是某个特定语言的解析器有问题。
在 nvim/lua/plugins/treesitter.lua 中添加 ignore_install 选项来排除有问题的解析器。

## 方案 4: 临时禁用 query 文件检查
在 treesitter.lua 的 opts 中添加:
```lua
opts = {
    -- ... 其他配置
    parser_install_dir = vim.fn.stdpath("data") .. "/treesitter",
    ignore_install = {}, -- 如果某个解析器有问题,可以添加到这里
}
```
