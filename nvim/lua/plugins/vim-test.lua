return {
    {
        "vim-test/vim-test",
        dependencies = {
            "preservim/vimux",
        },
        config = function()
            -- Define key mappings for running tests
            vim.api.nvim_set_keymap("n", "<leader>t", ":TestNearest<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>T", ":TestFile<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>a", ":TestSuite<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>l", ":TestLast<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>g", ":TestVisit<CR>", { noremap = true, silent = true })

            -- Correctly setting the strategy for vim-test
            vim.g["test#strategy"] = "vimux"
        end,
    },
}
