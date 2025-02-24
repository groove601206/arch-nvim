return {
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      -- Retrieve the OpenAI API key from the environment variable
      local openai_api_key = os.getenv("OPENAI_API_KEY")

      if not openai_api_key then
        print("Error: OPENAI_API_KEY is not set!")
        return
      end

      require("chatgpt").setup({
        openai_api_key = "echo $OPENAI_API_KEY"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim", -- optional
      "nvim-telescope/telescope.nvim"
    },
  },
}
