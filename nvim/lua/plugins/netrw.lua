-- Netew winsize
-- @default = 20
vim.g.netrw_winsize = 20

-- Netrw banner
-- 0 : Disable banner
-- 1 : Enable banner
vim.g.netrw_banner = 0

-- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
vim.g.netrw_keepdir = 1

-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- Human-readable files sizes
vim.g.netrw_sizestyle = "H"

-- Netrw list style
-- 0 : thin listing (one file per line)
-- 1 : long listing (one file per line with timestamp information and file size)
-- 2 : wide listing (multiple files in columns)
-- 3 : tree style listing
vim.g.netrw_liststyle = 3

-- Patterns for hiding files, e.g. node_modules
-- NOTE: this works by reading '.gitignore' file
vim.g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()

-- Show hidden files
-- 0 : show all files
-- 1 : show not-hidden files
-- 2 : show hidden files only
vim.g.netrw_hide = 1

-- Preview files in a vertical split window
-- vim.g.netrw_preview = 1

-- Open files in split
-- 0 : re-use the same window (default)
-- 1 : horizontally splitting the window first
-- 2 : vertically   splitting the window first
-- 3 : open file in new tab
-- 4 : act like "P" (ie. open previous window)
vim.g.netrw_browse_split = 4

-- Setup file operations commands
if os.getenv("OS") ~= "Windows_NT" then
    -- Enable recursive copy of directories in *nix systems
    vim.g.netrw_localcopydircmd = "cp -r"

    -- Enable recursive creation of directories in *nix systems
    vim.g.netrw_localmkdir = "mkdir -p"

    -- Enable recursive removal of directories in *nix systems
    -- NOTE: we use 'rm' instead of 'rmdir' (default) to be able to remove non-empty directories
    vim.g.netrw_localrmdir = "rm -r"
end

-- Highlight marked files in the same way search matches are
vim.cmd("hi! link netrwMarkFile Search")


local function is_empty(str)
  return str == "" or str == nil
end

local function netrw_maps()
    local netrw_buf = vim.api.nvim_get_current_buf()

    local opts = { silent = true}
    -- Toggle dotfiles
    vim.api.nvim_buf_set_keymap(netrw_buf, "n", ".", "gh", opts)

    -- Close netrw
    vim.api.nvim_buf_set_keymap(netrw_buf, "n", "q", ":Lexplore<CR>", opts)

    -- Create a new file and save it
    vim.api.nvim_buf_set_keymap(netrw_buf, "n", "c", "%:w<CR>:buffer #<CR>", opts)

    -- Create a new directory, ! means use original function
    vim.api.nvim_buf_set_keymap(netrw_buf, "n", "a", "d", {silent = true})


    -- Rename file
    vim.api.nvim_buf_set_keymap(netrw_buf, "n", "r", "R", opts)

    -- Remove file or directory
    --[[ vim.api.nvim_buf_set_keymap(netrw_buf, "n", "d", "D", {silent = true}) ]]

    -- -- Copy marked file
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "fc", "mc", opts)
    --
    -- -- Copy marked file in one step, with this we can put the cursor in a directory
    -- -- after marking the file to assign target directory and copy file
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "fC", "mtmc", opts)
    --
    -- -- Move marked file
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "fx", "mm", opts)
    --
    -- -- Move marked file in one step, same as fC but for moving files
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "fX", "mtmm", opts)
    --
    -- -- Execute commands in marked file or directory
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "fe", "mx", opts)
    --
    -- -- Show a list of marked files and directories
    -- vim.api.nvim_buf_set_keymap(
    --     netrw_buf,
    --     "n",
    --     "fm",
    --     ':echo "Marked files:\n" . join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>',
    --     opts
    -- )

    -- Show target directory
    vim.api.nvim_buf_set_keymap(
        netrw_buf,
        "n",
        "<F4>",
        ':echo "Target: " . netrw#Expose("netrwmftgt")<CR>',
        opts
    )

    -- -- Toggle the mark on a file or directory
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "<TAB>", "mf", opts)
    --
    -- -- Unmark all the files in the current buffer
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "<S-TAB>", "mF", opts)
    --
    -- -- Remove all the marks on all files
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "<Leader><TAB>", "mu", opts)
    --
    -- -- Create a bookmark
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "bc", "mb", opts)
    --
    -- -- Remove the most recent bookmark
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "bd", "mB", opts)
    --
    -- -- Jumo to the most recent bookmark
    -- vim.api.nvim_buf_set_keymap(netrw_buf, "n", "bj", "gb", opts)
end

local first_file_path = vim.v.argv[3]
local isSCP = false
if first_file_path and string.match(first_file_path, '^scp://') ~= nil then
    isSCP = true
end

if isSCP then
    vim.api.nvim_create_augroup('NetrwGroup', { clear = true })
    -- scp, config netrw
    vim.api.nvim_create_autocmd("FileType", {
        group = 'NetrwGroup',
        pattern = "netrw",
        callback = function()
            --[[ draw_icons() ]]
            netrw_maps()
        end,
    })

    -- vim.api.nvim_create_autocmd("TextChanged", {
    --     pattern = "*",
    --     callback = function()
    --         draw_icons()
    --     end,
    -- })

    vim.keymap.set({'n','v'}, '<F2>', '<cmd>Lexplore<CR>', { silent = true, desc = 'Explorer' })
    return {}
else
    return {
        {
            "nvim-neo-tree/neo-tree.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
            },
            config = function()
                -- scp, neotree
                vim.keymap.set({ "n", "v" }, "<F2>", [[<cmd>Neotree toggle<CR>]], {desc = "Neotree Explorer"})

                require("neo-tree").setup({
                    window = {
                        position = "left",
                        width = 35,
                    },
                    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
                    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
                    filesystem = {
                        bind_to_cwd = false,
                        follow_current_file = { enabled = true },
                        use_libuv_file_watcher = true,
                    },
                    default_component_configs = {
                        git_status = {
                            symbols = {
                                -- Change type
                                added     = "", -- or , but this is redundant info if you use git_status_colors on the name
                                modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                                deleted   = "✖", -- this can only be used in the git_status source
                                renamed   = "󰁕", -- this can only be used in the git_status source
                                -- Status type
                                untracked = "",
                                ignored   = "",
                                unstaged  = "✚",
                                staged    = "",
                                conflict  = "",
                            }
                        },
                    }
                })
            end
        },
    }
end
