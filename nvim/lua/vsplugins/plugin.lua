return {
  'vscode-neovim/vscode-multi-cursor.nvim',
  event = 'VeryLazy',
  cond = not not vim.g.vscode,
  config = function ()
  require('vscode-multi-cursor').setup { -- Config is optional
  -- Disable default mappings so we can register explicit bindings here
  default_mappings = false,
  -- If set to true, only multiple cursors will be created without multiple selections
  no_selection = false
  }
    -- Keep the default normal mapping but add visual/insert mappings to trigger
    -- adding next selection when text is selected in visual mode.
    vim.keymap.set('n', '<F7>', 'mciw*<Cmd>nohl<CR>', { remap = true })
    vim.keymap.set('x', '<F7>', function()
      -- Try VSCode built-in action first (works with editor selection),
      -- then fallback to the plugin API. Schedule to ensure selection state
      -- from Neovim is propagated to VSCode.
      vim.schedule(function()
        local ok, vscode = pcall(require, 'vscode')
        if ok and vscode and vscode.action then
          local s, err = pcall(function()
            vscode.action('editor.action.addSelectionToNextFindMatch')
          end)
          if s then return end
        end

        -- fallback to plugin API
        pcall(function()
          require('vscode-multi-cursor').addSelectionToNextFindMatch()
        end)
      end)
    end, { silent = true, noremap = true })
    vim.keymap.set('i', '<F7>', function()
      -- In insert mode ensure proper focus/mode change via with_insert
      pcall(function()
        local ok, vscode = pcall(require, 'vscode')
        if ok and vscode and vscode.with_insert then
          vscode.with_insert(function()
            -- schedule plugin call to allow VSCode selection to sync
            vim.schedule(function()
              pcall(function()
                require('vscode-multi-cursor').addSelectionToNextFindMatch()
              end)
            end)
          end)
        else
          -- fallback
          vim.schedule(function()
            pcall(function()
              require('vscode-multi-cursor').addSelectionToNextFindMatch()
            end)
          end)
        end
      end)
    end, { silent = true, noremap = true })
  end,
  opts = {},
}
