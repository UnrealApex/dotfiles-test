---@diagnostic disable: different-requires, mixed_table, undefined-field
-- TODO: format code
return {
  -- nicer ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  -- better file explorer
  {
    "justinmk/vim-dirvish",
    keys = "-",
    cmd = "Dirvish",
    init = function()
      -- check if a file argument supplied is a directory
      local argv_contains_dir = false
      ---@diagnostic disable-next-line: unused-local
      for k, v in pairs(vim.fn.argv()) do
        if vim.fn.isdirectory(v) == 1 then
          argv_contains_dir = true
        end
      end
      if vim.fn.argc() >= 1 and argv_contains_dir then
        require("lazy").load({ plugins = { "vim-dirvish" } })
      end
      -- load dirvish when a directory is opened
      vim.api.nvim_create_autocmd("BufNew", {
        callback = function()
          if require("lazy.core.config").plugins["vim-dirvish"]._.loaded then
            return true
          end

          if vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
            require("lazy").load({ plugins = { "vim-dirvish" } })
            return true
          end
        end,
      })
    end,
    dependencies = "bounceme/remote-viewer",
  },
  -- unix helpers
  {
    "tpope/vim-eunuch",
    cmd = {
      "Remove",
      "Unlink",
      "Delete",
      "Copy",
      "Duplicate",
      "Move",
      "Rename",
      "Chmod",
      "Mkdir",
      "Cfind",
      "Lfind",
      "Clocate",
      "Llocate",
      "SudoEdit",
      "SudoWrite",
      "Wall",
      "W",
    },
  },
  -- rsi style mappings
  {
    "tpope/vim-rsi",
    keys = {
      { "<C-a>", mode = {"c", "i"}},
      { "<C-x><C-a>", mode = {"c", "i"}},
      { "<C-b>", mode = {"c", "i"}},
      { "<C-d>", mode = {"c", "i"}},
      { "<C-e>", mode = {"c", "i"}},
      { "<C-f>", mode = {"c", "i"}},
      { "<C-g>", mode = {"c", "i"}},
      { "<C-t>", mode = {"c", "i"}},
      { "<M-BS>", mode = {"c", "i"}},
      { "<M-b>", mode = {"c", "i"}},
      { "<M-d>", mode = {"c", "i"}},
      { "<M-f>", mode = {"c", "i"}},
      { "<M-n>", mode = {"c", "i"}},
      { "<C-p>", mode = {"c", "i"}},
    }
   },
  -- move text
  {
    "echasnovski/mini.move",
    keys = {
      "<A-h>",
      "<A-j>",
      "<A-k>",
      "<A-l>",
      { "<A-h>", mode = "v" },
      { "<A-j>", mode = "v" },
      { "<A-k>", mode = "v" },
      { "<A-l>", mode = "v" },
    },
    config = true,
  },
  -- unimpaired mappings
  {
    "tpope/vim-unimpaired",
    keys = {
      { "[", mode = { "n", "v" } },
      { "]", mode = { "n", "v" } },
      "y",
    },
  },
  -- better git integration
  {
    "lewis6991/gitsigns.nvim",
    cond = vim.fn.executable("git") == 1,
    config = function()
      require("plugins.gitsigns")
    end,
    init = function ()
      vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("load_gitsigns", { clear = true }),
        callback = function ()
          if os.execute("git rev-parse --show-toplevel 2> /dev/null") == 0 then
              require("lazy").load({ plugins = { "gitsigns.nvim" } })
          end
        end
      })
    end
  },
  -- conveniently run git commands from vim
  {
    "tpope/vim-fugitive",
    dependencies = "lewis6991/gitsigns.nvim",
    cond = vim.fn.executable("git") == 1,
    cmd = {
      "G",
      "Git",
      "Ggrep",
      "Glgrep",
      "Gclog",
      "Gllog",
      "Gcd",
      "Glcd",
      "Gedit",
      "Gvsplit",
      "Gtabedit",
      "Gpedit",
      "Gdrop",
      "Gread",
      "Gwrite",
      "Gwq",
      "Gdiffsplit",
      "Ghdiffsplit",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GUnlink",
      "GBrowse",
    },
    ft = { "fugitive" },
  },
  -- surround
  {
    "kylechui/nvim-surround",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  -- repeat plugin commands
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
  },
  -- git commit browser
  {
    "sindrets/diffview.nvim",
    cond = vim.fn.executable("git") == 1 or vim.fn.executable("mercurial") == 1,
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- commenter
  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "gc", "gb", { "gc", mode = "v" }, { "gb", mode = "v" } },
    config = true,
  },
  -- zen mode
  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<leader>z",
        function()
          require("zen-mode").toggle()
        end,
      },
    },
    cmd = { "ZenMode" },
    config = true,
  },
  -- parentheses colorizer
  {
    "junegunn/rainbow_parentheses.vim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.cmd.RainbowParentheses()
    end,
  },
  -- turn off search highlighting automatically
  {
    "romainl/vim-cool",
    -- load vim-cool when doing a search
    keys = {
      "/",
      "?",
      "n",
      "N",
      "*",
      "#",
      { "*", mode = "v" },
      { "#", mode = "v" },
      "g*",
      "g#",
    },
  },
  -- lsp and completion stuff
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.lsp")
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    keys = {
      {
        "<leader>m",
        function()
          vim.cmd.Mason()
        end,
      },
    },
    config = true,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "neovim/nvim-lspconfig",
        opts = {
          automatic_installation = true,
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp")
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-nvim-lua",
    ft = "lua",
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    -- TODO: change this to a better event
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-calc",
    event = { "InsertEnter" },
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-emoji",
    keys = { ":", mode = "i" },
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("luasnip")
    end,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip/loaders/from_vscode").lazy_load()
        end,
      },
    },
  },
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function()
      require("neodev").setup()
      vim.lsp.start({
        name = "lua-language-server",
        cmd = { "lua-language-server" },
        before_init = require("neodev.lsp").before_init,
        root_dir = vim.fn.getcwd(),
        settings = { Lua = {} },
      })
    end,
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
      },
      mode = { "n", "v" },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettierd", "prettier" },
          typescript = { "prettierd", "prettier" },
          html = { "prettierd", "prettier" },
          css = { "prettierd", "prettier" },
          markdown = { "prettierd", "prettier" },
          python = {
            formatters = { "isort", "black" },
            run_all_formatters = true,
          },
          sh = { "shfmt" },
          json = { "jq" },
          java = { "google-java-format" },
          c = { "clang-format" },
          cs = { "clang-format" },
          cpp = { "clang-format" },
        },
        formatters = {
          shfmt = {
            prepend_args = { "--indent", "2" },
          },
        },
      },
    },
  },
  -- linting
  {
    "mfussenegger/nvim-lint",
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
    config = function()
      require("plugins.lint")
    end,
  },
  -- java lsp stuff
  { "mfussenegger/nvim-jdtls", ft = "java" },

  -- code action lightbulbs
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   event = "LspAttach",
  --   opts = {
  --     -- TODO: maybe use your own autocmd
  --     autocmd = {
  --       enabled = true,
  --       updatetime = 10,
  --     },
  --     sign = {
  --       enabled = false,
  --     },
  --     virtual_text = {
  --       enabled = true,
  --     },
  --   }
  -- },
  -- lsp window
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = true,
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>q",
        function()
          vim.cmd.Trouble()
        end,
      },
    },
  },
  -- improved syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cond = (
      vim.fn.executable("git") == 1
      or (vim.fn.executable("curl") == 1 and vim.fn.executable("tar") == 1)
    ),
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSConfigInfo",
      "TSDisable",
      "TSEditQuery",
      "TSEditQueryUserAfter",
      "TSEnable",
      "TSInstall",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSToggle",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    init = function()
      if vim.fn.argc() >= 1 then
        require("lazy").load({ plugins = { "nvim-treesitter" } })
      end
    end,
    config = function()
      require("plugins.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- automatically close pairs
  {
    "windwp/nvim-autopairs",
    -- load when starting bracket delimiter is pressed
    keys = {
      { "(", mode = "i" },
      { "{", mode = "i" },
      { "[", mode = "i" },
      { '"', mode = "i" },
      { "'", mode = "i" },
    },
    config = true,
  },
  -- fuzzy finder
  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
      },
      {
        "<leader><leader>",
        function()
          require("fzf-lua").buffers()
        end,
      },
      {
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
      },
      {
        "<leader>fd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
      },
      {
        "<leader>fo",
        function()
          require("fzf-lua").oldfiles()
        end,
      },
      {
        "<leader>fs",
        function ()
          require("fzf-lua").lsp_document_symbols()
        end
      },
    },
    cmd = { "FzfLua" },
    cond = vim.fn.executable("fzf") == 1,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      "telescope",
      previewers = {
        builtin = {
          extensions = {
            -- neovim terminal only supports `viu` block output
            ["gif"] = { "chafa" },
            ["jpg"] = { "chafa" },
            ["png"] = { "chafa"},
            ["webp"] = { "chafa" },
          },
        },
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      {
        "<leader>qs", function()
          require("persistence").load()
        end
      },
      {"<leader>ql", function()
        require("persistence").load({ last = true })
      end
      },
      {"<leader>qd", function ()
        require("persistence").stop()
      end}
    },
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = vim.opt.sessionoptions:get(),
    }
  },
  -- debugging
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
      },
      {
        "<F1>",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<F2>",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<F3>",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>B",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
      },
      {
        "<leader>ds",
        function()
          require("dap.ui.widgets").scopes()
        end,
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
      },
      -- dap ui keymaps
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
      },
      {
        "<leader>de",
        mode = { "n", "v" },
        function()
          require("dapui").eval()
        end,
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("[Expression] > "))
        end,
      },
    },
    cmd = {
      "DapInstall",
      "DapShowLog",
      "DapStepOut",
      "DapContinue",
      "DapStepInto",
      "DapStepOver",
      "DapTerminate",
      "DapUninstall",
      "DapToggleRepl",
      "DapSetLogLevel",
      "DapRestartFrame",
      "DapLoadLaunchJSON",
      "DapToggleBreakpoint",
    },
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "williamboman/mason.nvim",
        opts = {
          automatic_installation = true,
        },
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
      },
      -- TODO: add more debug adapters
      {
        "jbyuki/one-small-step-for-vimkind",
      },
      {
        "mfussenegger/nvim-dap-python",
      },
    },
    config = function()
      ---@diagnostic disable-next-line: different-requires
      require("plugins.dap")
    end,
  },
  -- additional text objects
{
  "echasnovski/mini.ai",
  -- keys = {
  --   { "a", mode = { "x", "o" } },
  --   { "i", mode = { "x", "o" } },
  -- },
  event = { "BufReadPost", "BufNewFile" },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },
        g = function() -- Whole buffer, similar to `gg` and 'G' motion
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
  end,
  },
  -- heuristically set buffer options
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },
  -- icons
  "nvim-tree/nvim-web-devicons",
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup({
        transparent = true,
        on_highlights = function(highlights, colors)
          highlights.StatusLine = colors.Normal
          highlights.StatusLineNC = colors.Normal
          highlights.WinBar = {
            bg = colors.none
          }
          highlights.WinBarNC = {
            bg = colors.none
          }
        end,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  -- markdown preview
  {
    "ellisonleao/glow.nvim",
    cond = vim.fn.executable("glow") == 1,
    ft = "markdown",
    config = true,
  },
  -- color previews
  {
    "NvChad/nvim-colorizer.lua",
    ft = {
      "cfg",
      "conf",
      "css",
      "dosini",
      "html",
      "javascript",
      "sass",
      "sh",
      "zsh",
    },
    -- REFACTOR: get filetypes from ft
    opts = {
      filetypes = {
        "cfg",
        "conf",
        "css",
        "dosini",
        "html",
        "javascript",
        "sass",
        "sh",
        "zsh",
      },
    },
  },
}
