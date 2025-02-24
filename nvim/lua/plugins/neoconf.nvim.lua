return {
    -- Load neoconf.nvim first
    {
        "folke/neoconf.nvim",
        priority = 1000, -- Ensures it loads first
        config = function()
            require("neoconf").setup({
                local_settings = ".neoconf.json",
                global_settings = "neoconf.json",
                import = {
                    vscode = true,
                    coc = true,
                    nlsp = true,
                },
                live_reload = true,
                filetype_jsonc = true,
                plugins = {
                    lspconfig = { enabled = true },
                    jsonls = { enabled = true, configured_servers_only = true },
                    lua_ls = { enabled_for_neovim_config = true, enabled = false },
                },
            })

            -- Keymaps for Neoconf
            local map = vim.keymap.set

            map("n", "<leader>cc", "<cmd>Neoconf<CR>", { desc = "Open Neoconf UI" })
            map("n", "<leader>ccl", "<cmd>Neoconf local<CR>", { desc = "Edit Local Neoconf" })
            map("n", "<leader>ccg", "<cmd>Neoconf global<CR>", { desc = "Edit Global Neoconf" })
            map("n", "<leader>ccs", "<cmd>Neoconf show<CR>", { desc = "Show Merged Neoconf" })
            map("n", "<leader>cclsp", "<cmd>Neoconf lsp<CR>", { desc = "Show Merged LSP Config" })
        end,
    },

    -- LSP config (ensure this runs AFTER neoconf.nvim)
    {
        "neovim/nvim-lspconfig",
        dependencies = { "folke/neoconf.nvim" },
        config = function()
            local lspconfig = require("lspconfig")

            -- Lua LSP setup
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                    },
                },
            })

            -- Python LSP setup
            lspconfig.pyright.setup({})
        end,
    },
}
