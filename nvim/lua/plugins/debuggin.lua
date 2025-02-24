return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio", -- Required for nvim-dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- 🔥 Setup DAP UI
            dapui.setup({
                icons = {
                    expanded = '▾',  -- Icon when a node is expanded (default)
                    collapsed = '▸', -- Icon when a node is collapsed (default)
                    current_frame = '',  -- Red Bug Nerd Font Icon for current frame
                }
            })

            -- 🔥 Configure DAP Adapters (Python Example)
            dap.adapters.python = {
                type = "executable",
                command = vim.fn.expand("~/.virtualenvs/debugpy/bin/python"), -- Adjust path if needed
                args = { "-m", "debugpy.adapter" },
            }

            -- 🔥 Configure DAP for Python Debugging
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch File",
                    program = "${file}",
                    pythonPath = function()
                        return vim.fn.exepath("python") -- Auto-detect Python path
                    end,
                },
            }

            -- 🔥 Automatically Open/Close DAP UI
            dap.listeners.after["event_initialized"]["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.after["event_terminated"]["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.after["event_exited"]["dapui_config"] = function()
                dapui.close()
            end

            -- 🔥 Key Mappings for Debugging
            vim.keymap.set("n", "<Leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<Leader>dc", function() dap.continue() end, { desc = "Continue Execution" })
            vim.keymap.set("n", "<Leader>ds", function() dap.step_over() end, { desc = "Step Over" })
            vim.keymap.set("n", "<Leader>di", function() dap.step_into() end, { desc = "Step Into" })
            vim.keymap.set("n", "<Leader>do", function() dap.step_out() end, { desc = "Step Out" })
            vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
            vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end, { desc = "Toggle Debugger UI" })
        end,
    },
}
