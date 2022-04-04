vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'navarasu/onedark.nvim'
  require('onedark').setup {
    style = 'dark',
    transparent = true,
    code_style = {
      comments = 'italic',
      keywords = 'italic',
      functions = 'none',
      strings = 'none',
      variables = 'none',
    },
    diagnostics = {
      background = false,
    },
  }
  local color = require 'onedark.colors'
  local odconfig = vim.g.onedark_config
  require('onedark').setup {
    highlights = {
      TSConstructor = { fg = color.blue, fmt = odconfig.code_style.functions },
    },
  }
  require('onedark').load()

  use {
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  require('lualine').setup {
    options = { theme = 'onedark' },
    sections = {
      lualine_b = {
        'b:gitsigns_status',
      },
      lualine_y = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
        },
      },
      lualine_z = { 'progress', 'location' },
    },
  }

  use {
    'akinsho/bufferline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  require('bufferline').setup {
    options = {
      middle_mouse_command = 'vertical sbuffer%d',
      diagnostics = 'nvim_lsp',
    },
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }
  require('gitsigns').setup()

  use 'andymass/vim-matchup'
  use 'jiangmiao/auto-pairs'
  use 'Vimjas/vim-python-pep8-indent'
  use 'skywind3000/asyncrun.vim'
  use 'djoshea/vim-autoread'
  use 'preservim/nerdcommenter'
  use 'tpope/vim-surround'
  use 'lambdalisue/suda.vim'
  use 'sheerun/vim-polyglot'
  use 'sbdchd/neoformat'

  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
  }

  use {
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  use 'tami5/lspsaga.nvim'
  local vim_map = vim.api.nvim_buf_set_keymap
  vim_map(
    0,
    'n',
    'gr',
    '<cmd>Lspsaga rename<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    'gx',
    '<cmd>Lspsaga code_action<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'x',
    'gx',
    ':<c-u>Lspsaga range_code_action<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    'K',
    '<cmd>Lspsaga hover_doc<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    'go',
    '<cmd>Lspsaga show_line_diagnostics<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    'gj',
    '<cmd>Lspsaga diagnostic_jump_next<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    'gk',
    '<cmd>Lspsaga diagnostic_jump_prev<cr>',
    { silent = true, noremap = true }
  )
  vim_map(
    0,
    'n',
    '<C-u>',
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>",
    {}
  )
  vim_map(
    0,
    'n',
    '<C-d>',
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>",
    {}
  )

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
        scope_incremental = '<TAB>',
      },
    },
    -- indent = {
    --   enable = true,
    -- },
    matchup = {
      enable = true,
    },
  }
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.wo.foldlevel = 99

  use 'lukas-reineke/indent-blankline.nvim'
  require('indent_blankline').setup {
    show_current_context = true,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }
  require('nvim-tree').setup {
    open_on_setup = true,
    open_on_tab = true,
    diagnostics = {
      enable = true,
    },
  }

  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'rafamadriz/friendly-snippets'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-calc'
  use 'hrsh7th/cmp-emoji'
  use 'f3fora/cmp-spell'
  use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
  }

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      -- update diagnostics in insert mode
      update_in_insert = true,
    }
  )

  require('luasnip/loaders/from_vscode').lazy_load()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  local servers = { 'pyright', 'clangd', 'bashls' }
  local nvim_lsp = require 'lspconfig'
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      capabilities = capabilities,
    }
  end
  nvim_lsp.jdtls.setup { cmd = { 'jdtls' } }
  nvim_lsp.sumneko_lua.setup {
    cmd = { 'sumneko' },
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = { 'vim', 'use' },
        },
        workspace = {
          maxPreload = 2000,
          library = '${3rd}/love2d/library',
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

  require('cmp_tabnine.config'):setup {
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
  }

  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  cmp.setup {
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = require('lspkind').presets.default[vim_item.kind]
          .. ' '
          .. vim_item.kind
        vim_item.menu = ({
          luasnip = '[LuaSnip]',
          cmp_tabnine = '[TabNine]',
          nvim_lsp = '[LSP]',
          buffer = '[Buffer]',
          path = '[Path]',
          calc = '[Calc]',
          emoji = '[Emoji]',
          spell = '[Spell]',
        })[entry.source.name]
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<Tab>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<C-n>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active(1) then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end,
      ['<C-p>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.choice_active(-1) then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end,
      ['<C-j>'] = function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end,
      ['<C-k>'] = function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'luasnip' },
      { name = 'cmp_tabnine' },
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'spell' },
    },
  }
end)
