-- 🌟 Set leader key early
vim.g.mapleader = " "      -- Space as the leader key
vim.g.maplocalleader = " " -- Local leader key

-- 🛠️ Basic Neovim Settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4           -- Number of spaces per tab
vim.opt.shiftwidth = 4        -- Spaces per indentation level
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.smartindent = true    -- Automatically indent new lines
vim.opt.autoindent = true     -- Maintain indentation levels
vim.opt.termguicolors = true  -- Enable 24-bit colors
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.cursorline = true     -- Highlight the cursor line
vim.opt.mouse = "a"           -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard (ensure xclip/xsel on Linux)

-- 📂 Lazy.nvim Bootstrapping
local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 🚀 Plugin Setup with Lazy.nvim
require("lazy").setup("plugins")

-- 🎨 Make CursorLine and CursorColumn a Little Lighter
vim.cmd([[
  augroup CustomCursorLine
    autocmd!
    autocmd ColorScheme * highlight CursorLine guibg=#2c2c2c
    autocmd ColorScheme * highlight CursorColumn guibg=#2a2a2a
  augroup END
]])
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c2c2c" })                  -- Lighter gray background for cursor line
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d0d0d0", bold = true })   -- Light gray line number
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2a2a2a" })                -- Darker gray background for cursor column
vim.api.nvim_set_hl(0, "CursorColumnNr", { fg = "#d0d0d0", bold = true }) -- Light gray number in column

-- 🔧 Ensure Mason LSP works correctly on both macOS and Linux
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/share/nvim/mason/bin")

-- 🛠️ OS-Specific Fixes
if vim.fn.has("mac") == 1 then
    -- macOS-specific settings (if any)
elseif vim.fn.has("unix") == 1 then
    -- Linux-specific settings (e.g., ensure xclip for clipboard)
    if vim.fn.executable("xclip") == 0 and vim.fn.executable("xsel") == 0 then
        print("Warning: Clipboard support requires xclip or xsel on Linux.")
    end
end

-- 📈 Additional optional settings
vim.opt.swapfile = false  -- Disable swap files
vim.opt.backup = false    -- Disable backups
