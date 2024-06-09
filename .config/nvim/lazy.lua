-- vim:foldlevel=2

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        -- Open a terminal buffer at the selected directory
        vim.keymap.set('n', '<C-CR>',
          function ()
            local api = require('nvim-tree.api')

            if api.tree.is_tree_buf() then
              api.fs.copy.absolute_path()
              local dir = vim.fn.getreg('+')
              vim.api.nvim_command('tabnew | terminal cd \'' .. dir .. '\' && bash')
            else
              print("Not a nvim-tree buffer!")
            end
          end
        )
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "python",
        },
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = false,
        },
      }
      vim.cmd("syntax off")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        signs = {
          add          = { text = '+' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end)
          --
          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end)
          --
          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
          map('n', '<leader>td', gitsigns.toggle_deleted)
          --
          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup {}
      require("lspconfig").lua_ls.setup {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
            -- Accept currently selected item. Set `select` to `false` to only
            --  confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
})
