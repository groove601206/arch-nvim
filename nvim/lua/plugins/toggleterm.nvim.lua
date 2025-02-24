return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,  -- Default height for horizontal terminals
        open_mapping = nil,  -- Disable default mappings
        direction = "horizontal",  -- Default direction (horizontal)
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      })

      local Terminal = require("toggleterm.terminal").Terminal

      -- Define horizontal terminal with Zsh
      local horizontal_term = Terminal:new({
        cmd = "zsh",  -- Change to Zsh shell
        hidden = true,
        direction = "horizontal",  -- Horizontal terminal
      })

      -- Define vertical terminal with Zsh
      local vertical_term = Terminal:new({
        cmd = "zsh",  -- Change to Zsh shell
        hidden = true,
        direction = "vertical",  -- Vertical terminal
      })

      -- Define floating terminal with Zsh and adjusted size
      local float_term = Terminal:new({
        cmd = "zsh",  -- Change to Zsh shell
        hidden = true,
        direction = "float",  -- Floating terminal
        float_opts = {
          border = "curved",  -- Optional, can change border style (none, single, rounded, etc.)
          width = 120,  -- Increased width of the floating terminal
          height = 30,  -- Increased height of the floating terminal
          winblend = 5,  -- Adjust transparency level (0-100)
        },
      })

      -- Keybindings to toggle different terminals
      vim.keymap.set("n", "<Leader>tf", function()
        float_term:toggle()
      end, { desc = "Toggle Floating Terminal" })

      vim.keymap.set("n", "<Leader>th", function()
        horizontal_term:toggle()
      end, { desc = "Toggle Horizontal Terminal" })

      vim.keymap.set("n", "<Leader>tv", function()
        vertical_term:toggle()
      end, { desc = "Toggle Vertical Terminal" })

      -- Keybinding to close all terminals
      vim.keymap.set("n", "<Leader>tq", function()
        vim.cmd("ToggleTermExit")
      end, { desc = "Close All Terminals" })
    end,
  },
}
