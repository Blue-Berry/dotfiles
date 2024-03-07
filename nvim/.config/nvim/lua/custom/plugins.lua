local plugins = {
  {
    "tjdevries/ocaml.nvim",
    ft = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
    config = function()
      require("ocaml").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
    dependencies = {
      -- "jose-elias-alvarez/null-ls.nvim",
      "nvimtools/none-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williambowman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "gopls",
        "python-lsp-server",
        "black",
        "prettier",
        "lua-language-server",
        "ocaml-lsp",
        "ocamlformat",
        "bash-language-server",
        "clangd",
      },
    },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
      local rt = require "rust-tools"
      rt.setup(opts)
      rt.inlay_hints.set()
      rt.inlay_hints.enable()
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      -- Update the config to allow for completion of rust crates
      table.insert(M.sources, { name = "crates" })
      -- Don't automatically select for auto completion
      if M.completion then
        M.completion.completeopt = "menu,menuone,noselect,noinsert"
      end
      M.preselect = require("cmp").PreselectMode.None
      M.mapping["<CR>"] = require("cmp").mapping.confirm {
        behavior = require("cmp").ConfirmBehavior.Insert,
        select = false,
      }
      return M
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    {
      "folke/zen-mode.nvim",
      dependencies = "folke/twilight.nvim",
      lazy = false,
      opts = {},
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    lazy = false,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
      { "kevinhwang91/promise-async" },
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            -- foldfunc = "builtin",
            -- setopt = true,
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    config = function()
      -- Fold options
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
  },
}
return plugins
