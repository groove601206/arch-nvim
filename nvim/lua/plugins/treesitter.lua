return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Ensure parsers stay updated
    event = { "BufReadPost", "BufNewFile" }, -- Load only when needed
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "python" }, -- Install only needed parsers
            highlight = { enable = true },
            indent = { enable = true },
            sync_install = false, -- Non-blocking installation
        })
    end,
}
