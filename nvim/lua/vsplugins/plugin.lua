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

    -- Ctrl+n: 添加下一个相同单词到多光标选择
    vim.keymap.set({'n', 'x', 'i'}, '<C-n>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next find match' })

    -- Ctrl+x: 跳过当前匹配，移动到下一个
    vim.keymap.set({'n', 'x', 'i'}, '<C-x>', function()
      require('vscode').action('editor.action.moveSelectionToNextFindMatch')
    end, { desc = 'Skip current and move to next match' })

    -- Ctrl+p: 返回到上一个匹配
    vim.keymap.set({'x'}, '<C-p>', function()
      require('vscode').action('editor.action.moveSelectionToPreviousFindMatch')
    end, { desc = 'Move to previous match' })

    -- Ctrl+a: 选择所有匹配项（相当于 Ctrl+Shift+L）
    vim.keymap.set({'n', 'x', 'i'}, '<C-a>', function()
      cursor.selectHighlights()
    end, { desc = 'Select all matches' })

    -- vim.keymap.set({'n', 'x', 'i'}, '<C-n>', 'mciw*<Cmd>nohl<CR>', { remap = true })
    
    -- vim.keymap.set({ 'n','x' }, 'I', function()
    --     local mode = vim.api.nvim_get_mode().mode
    --     cursor.start_left_edge { no_selection = mode == '\x16' }
    -- end, { desc = 'Multi-cursor insert at left edge' })
    
    -- vim.keymap.set({ 'n','x' }, 'i', function()
    --     local mode = vim.api.nvim_get_mode().mode
    --     cursor.start_left { no_selection = mode == '\x16' }
    -- end, { desc = 'Multi-cursor insert at right edge'})
    
    -- vim.keymap.set({ 'x' }, 'a', function()
    --     local mode = vim.api.nvim_get_mode().mode
    --     cursor.start_right { no_selection = mode == '\x16' }
    -- end, { desc = 'Multi-cursor append at right edge' })

  end,
  opts = {},
}
