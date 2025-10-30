return {
  'vscode-neovim/vscode-multi-cursor.nvim',
  event = 'VeryLazy',
  cond = vim.g.vscode,
  config = function ()
    require('vscode-multi-cursor').setup {
      -- Enable default mappings: mc, mi, ma, etc.
      default_mappings = true,
      no_selection = false
    }

    local cursor = require('vscode-multi-cursor')

    -- 使用 vscode-multi-cursor 插件的 API（关键！）
    -- 这个 API 会正确处理多光标状态，不会在按 i 时合并

    -- Visual/Normal 模式：Ctrl+n 添加下一个相同单词
    vim.keymap.set({'n', 'x', 'i'}, '<C-n>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add next match to multi-cursor' })

    -- Visual/Normal 模式：Ctrl+x 跳过当前，选择下一个
    vim.keymap.set({'n', 'x', 'i'}, '<C-x>', function()
      cursor.skipSelection()
    end, { desc = 'Skip current and select next' })

    -- Visual/Normal 模式：Ctrl+Shift+n 选择所有相同单词（可选）
    vim.keymap.set({'n', 'x', 'i'}, '<C-S-n>', function()
      cursor.selectHighlights()
    end, { desc = 'Select all matches' })

    -- 工作流程：
    -- 1. 光标在单词上（或按 v 选中单词）
    -- 2. 按 Ctrl+n → 添加下一个相同单词（插件会创建多光标）
    -- 3. 继续按 Ctrl+n → 继续添加更多
    -- 4. 按 d/x → 删除所有选中内容
    -- 5. 按 i → 在所有位置进入插入模式（应该能工作！）
    -- 6. 输入内容 → 所有位置同时输入
    -- 7. 按 Esc → 完成
  end,
  opts = {},
}
