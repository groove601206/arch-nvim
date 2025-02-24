return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright" }, -- Ensure Pyright is installed
                automatic_installation = true,
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    local lspconfig = require("lspconfig")

                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                    if ok then
                        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
                    else
                        vim.notify("Warning: cmp_nvim_lsp not found, using default LSP capabilities", vim.log.levels.WARN)
                    end

                    -- Define the root directory function for all LSPs
                    local function root_dir(fname)
                        return vim.fs.dirname(vim.fs.find({ ".git", "init.lua" }, { upward = true, path = fname })[1])
                    end

                    -- LSP server configurations
                    local servers = {
                        lua_ls = {
                            root_dir = root_dir,
                        },
                        pyright = {
                            -- Check for Homebrew or Mason installation
                            cmd = vim.fn.executable("/opt/homebrew/bin/pyright-langserver") == 1
                                and { "/opt/homebrew/bin/pyright-langserver", "--stdio" }
                                or { vim.fn.expand("~/.local/share/nvim/mason/bin/pyright-langserver"), "--stdio" },
                            settings = {
                                python = {
                                    analysis = {
                                        typeCheckingMode = "basic",
                                        autoSearchPaths = true,
                                        diagnosticMode = "workspace",
                                        useLibraryCodeForTypes = true,
                                    },
                                },
                            },
                        },
                    }

                    -- Apply configuration for the server
                    if servers[server_name] then
                        lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
                            capabilities = capabilities,
                        }, servers[server_name]))
                    end
                end,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- Set Python 3 host program for Neovim (for Pyright and other Python LSPs)
            vim.g.python3_host_prog = '/Users/admin/.pyenv/versions/nvim-env/bin/python3'

            -- Setup diagnostic signs
            local signs = {
                Error = "",
                Warn = "",
                Hint = "",
                Info = "",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl })
            end

            -- Keybindings for LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local opts = { noremap = true, silent = true, buffer = bufnr }

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ac", function()
                        vim.lsp.buf.code_action()
                    end, { desc = "Show available code actions", noremap = true, buffer = bufnr })
                end,
            })

            -- Autoformatting setup
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    vim.lsp.buf.format({ timeout_ms = 1000 })
                end,
            })

            -- Autoorganize imports for Python
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.py",
                callback = function()
                    vim.lsp.buf.execute_command({
                        command = "python.sortImports",
                        arguments = { vim.api.nvim_buf_get_name(0) },
                    })
                end,
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = true, -- Show progress messages
                    },
                    signature = {
                        enabled = true, -- Show LSP signature help
                    },
                    markdown = {
                        enabled = true, -- Enable markdown rendering
                    },
                },
                cmp = {
                    documentation = {
                        enabled = true, -- Show completion documentation in Noice
                    },
                },
            })
        end,
    },
}
