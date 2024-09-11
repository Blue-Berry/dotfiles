---@type ChadrcConfig
local M = {}

M.ui = { theme = "chadracula", transparency = false }
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

vim.opt.scrolloff = 6
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
vim.opt.expandtab = true
return M
