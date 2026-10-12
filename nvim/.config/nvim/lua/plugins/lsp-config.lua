return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "lua_ls",
        "basedpyright",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          enabled = false,
        },
        pylyzer = {
          enabled = false,
        },
        puppet = {
          enabled = false,
        },
        ruff = {
          capabilities = {
            general = {
              positionEncodings = { "utf-16" },
            },
          },
        },
        basedpyright = {
          capabilities = {
            general = {
              positionEncodings = { "utf-16" },
            },
          },
        },
        lua_ls = {},
      },
    },
  },
}
