local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.black,
  -- formatting.rustfmt,
  formatting.gofmt,
  formatting.ocamlformat,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
