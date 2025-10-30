return {
  'vscode-neovim/vscode-multi-cursor.nvim',
  event = 'VeryLazy',
  cond = vim.g.vscode,
  config = function ()
    require('vscode-multi-cursor').setup {
      -- Keep default mappings (mc, mi, ma, etc.)
      default_mappings = true,
      -- Create selections (not just cursors)
      no_selection = false
    }

    local cursor = require('vscode-multi-cursor')

    -- Visual mode: Ctrl+n to create cursor on selection and add next match
    -- This works like VSCode's Ctrl+D
    vim.keymap.set('x', '<C-n>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next find match' })

    -- Insert mode: Ctrl+n to add next match
    vim.keymap.set('i', '<C-n>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next find match' })

    -- Normal mode: Ctrl+n to add next match
    vim.keymap.set('n', '<C-n>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next find match' })


    -- Visual mode: Ctrl+x to skip current and select next
    vim.keymap.set('x', '<C-x>', function()
      -- Use VSCode's native skip function
      require('vscode').action('editor.action.moveSelectionToNextFindMatch')
    end, { desc = 'Skip and select next match' })

    -- Alternative: Ctrl+d (like VSCode native)
    vim.keymap.set({ 'n', 'x', 'i' }, '<C-d>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next (Ctrl+D)' })

    -- F7 as alternative to Ctrl+n
    vim.keymap.set({ 'n', 'x' }, '<F7>', function()
      cursor.addSelectionToNextFindMatch()
    end, { desc = 'Add selection to next (F7)' })

    -- Normal mode: Quick select word under cursor
    -- Press this to start, then press Ctrl+n to add more
    vim.keymap.set('n', 'mw', 'mciw', { remap = true, desc = 'Select current word (multi-cursor)' })
  end,
  opts = {},
}
