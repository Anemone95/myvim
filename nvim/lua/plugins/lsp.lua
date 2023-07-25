local lang2server = {
    clang = {
        clangd = {},
    },
    venv = {
        pyright = {},
    },
    cargo = {
        neocmake = {},
    },
    tsc = {
        tsserver = {},
    },
    opam = {
        ocamllsp = {},
    },
}
local function command_exists(command)
    local handle = io.popen("command -v " .. command)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

local function mergeTables(t1, t2)
    return table.move(t2, 1, #t2, #t1 + 1, t1)
end

local function printTable(t, indent)
    indent = indent or 0
    local indentStr = string.rep("  ", indent)

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indentStr .. k .. ":")
            printTable(v, indent + 1)
        else
            print(indentStr .. k .. ": " .. tostring(v))
        end
    end
end
local onlyx64supports = {
    codeqlls = {},
    lemminx = {}, -- FIXME
}

local servers = {
    bashls = {},
    cssls = {},
    dotls = {},
    dockerls = {},
    docker_compose_language_service = {},
    -- gopls = {},
    html = {},
    jsonls = {},
    jdtls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    marksman = {},
    intelephense = {},
    powershell_es = {},
    rust_analyzer = {},
    sqlls = {},
    taplo = {},
    texlab = {},
    vimls = {},
    volar = {},
    yamlls = {},
}

local function jump_to_next_diagnostic()
    local current_bufnr = vim.api.nvim_get_current_buf()
    local next_diagnostic = vim.lsp.diagnostic.get_next(current_bufnr, nil, { severity_min = vim.lsp.protocol.DiagnosticSeverity.Warning })

    if not next_diagnostic then
        next_diagnostic = vim.lsp.diagnostic.get_next(current_bufnr, nil, { severity_min = vim.lsp.protocol.DiagnosticSeverity.Error })
    end

    if next_diagnostic then
        vim.api.nvim_win_set_cursor(0, { next_diagnostic.range.start.line + 1, next_diagnostic.range.start.character + 1 })
    else
        print("No more warnings or errors.")
    end
end

local function goToImplementationOrDefinition()
    local telescope = require("telescope.builtin")

    -- 尝试调用 lsp_implementations
    local success, implementations = pcall(telescope.lsp_implementations)
    if success and implementations then
        return implementations
    end

    -- 尝试调用 lsp_definitions
    local success, definitions = pcall(telescope.lsp_definitions)
    if success and definitions then
        return definitions
    end

    -- 尝试调用 vim.lsp.buf.declaration
    local success, definitions = pcall(vim.lsp.buf.declaration)
    if success and definitions then
        return definitions
    end
    -- 尝试调用 vim.lsp.buf.declaration
    local success, definitions = pcall(vim.lsp.buf.type_definition)
    if success and definitions then
        return definitions
    end

    return require('telescope.builtin').lsp_references()
end


return {
    {
        "williamboman/mason.nvim",
        build = { ":MasonUpdate", "" } -- :MasonUpdate updates registry contents
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig",
            "folke/neoconf.nvim",
            "folke/neodev.nvim",
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
            },
            "nvimdev/lspsaga.nvim",

        },
        config = function()
            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end
                nmap("gq", vim.diagnostic.goto_next, "[G]oto next diagnostic")
                nmap('gi', goToImplementationOrDefinition, '[G]oto [I]mplementation')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
                vim.keymap.set({ "v", "n" }, "=", function()
                    vim.lsp.buf.format { async = true }
                end, { desc = "[F]ormat code" })
                nmap('K', "<cmd>Lspsaga hover_doc<CR>", 'Hover Documentation')
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('gd', require "telescope.builtin".lsp_definitions, '[G]oto [D]efinition')
                -- nmap('gi', require "telescope.builtin".lsp_implementations, '[G]oto [I]mplementation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')
                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ca', "<cmd>Lspsaga code_action<CR>", '[C]ode [A]ction')
                nmap('<leader>da', require "telescope.builtin".diagnostics, '[D]i[A]gnostics')
                -- nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

            end

            for lang, _servers in pairs(lang2server) do
                if command_exists(lang) then
                    for k,v in pairs(_servers) do
                        servers[k] = v
                    end
                end
            end

            require("neoconf").setup()
            require("neodev").setup()
            require("fidget").setup()
            require("lspsaga").setup()
            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_installation = false,
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            settings = servers[server_name],
                            on_attach = on_attach,
                        }
                    end,
                }
            })
        end
    },
}
