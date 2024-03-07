local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  inlay_hints = { show_parameter_hints = true, parameter_hints_prefix = "=>" },
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_dir = util.root_pattern(".git", "setup.py", "setup.cfg", "requirements.txt"),
  settings = {
    pylsp = {
      plugins = {
        -- pycodestyle = {
        --     ignore = {'W391'},
        --     maxLineLength = 1000
        -- },
        -- formatter options
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- type checker
        pylsp_mypy = { enabled = true },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        pyls_isort = { enabled = true },
      },
    },
  },
}

lspconfig.ocamllsp.setup {
  -- on_attach = on_attach,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- code lens
    local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
      group = codelens,
      callback = function()
        -- vim.lsp.codelens.refresh()
        require("custom.configs.codelens").refresh_virtlines()
      end,
      buffer = bufnr,
    })

    vim.keymap.set(
      "n",
      "<leader>tt",
      require("custom.configs.codelens").toggle_virtlines,
      { silent = true, desc = "Toggle code lens", buffer = 0 }
    )
  end,
  settings = {
    codelens = { enable = true },
  },
  capabilities = capabilities,
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
  root_dir = util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace"),
  get_language_id = function(_, ftype)
    return ftype
  end,
}

lspconfig.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "zsh" },
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--header-insertion=iwyu" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = util.root_pattern(".git", "compile_commands.json", "compile_flags.txt", ".clangd"),
}
