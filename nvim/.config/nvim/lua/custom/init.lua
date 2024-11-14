local o = vim.o

o.expandtab = true
o.smartindent = true
-- o.tabstop = 4
o.shiftwidth = 4

-- Remove tab for copilot
vim.g.copilot_assume_mapped = true

-- Set relative line numbers
vim.wo.relativenumber = true

vim.wo.wrap = false
vim.scrolloff = 6

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- lspconfig format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = buffer,
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Open nvim-tree if passed a directory
-- local autocmd = vim.api.nvim_create_autocmd
-- local function open_nvim_tree(data)
--   -- buffer is a directory
--   local directory = vim.fn.isdirectory(data.file) == 1
--   -- buffer is a [No Name]
--   local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
--   if not directory and not no_name then
--     return
--   end
--   if directory then
--     -- change to the directory
--     vim.cmd.cd(data.file)
--   end
--   -- open the tree
--   -- require("nvim-tree.api").tree.open()
--   require("telescope.builtin").find_files()
-- end
-- autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Remember last cursor position
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds { group = lastplace }
vim.api.nvim_create_autocmd("BufReadPost", {
  group = lastplace,
  pattern = { "*" },
  desc = "remember last cursor place",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font:h12"
    vim.g.neovide_scale_factor = 0.8
end
