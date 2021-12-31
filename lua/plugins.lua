vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'monsonjeremy/onedark.nvim'
  require('onedark').setup{
    transparent = true
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  require('lualine').setup{
    options = { theme = 'onedark' },
    sections = {
      lualine_b = {
        'b:gitsigns_status'
      },
      lualine_y = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic', 'coc' }
        }
      },
      lualine_z = { 'progress', 'location' }
    }
  }

  use {
    'akinsho/bufferline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  require('bufferline').setup{
    options = {
      middle_mouse_command = "vertical sbuffer%d",
      diagnostics = 'nvim_lsp'
    }
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }
  require('gitsigns').setup()

  use 'andymass/vim-matchup'

  use {
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'glepnir/lspsaga.nvim'
  local saga = require('lspsaga')
  saga.init_lsp_saga()

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  require('nvim-treesitter.configs').setup{
    matchup = {
      enable = true,
    },
  }

  use 'lukas-reineke/indent-blankline.nvim'
  require('indent_blankline').setup{
    show_current_context = true
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }
  require('nvim-tree').setup{
    open_on_setup = true,
    auto_close = true,
    open_on_tab = true,
    diagnostics = {
      enable = true,
    }
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

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- update diagnostics in insert mode
      update_in_insert = true,
    }
  )

  require('luasnip/loaders/from_vscode').lazy_load()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  local servers = { 'pyright', 'clangd' }
  local nvim_lsp = require('lspconfig')
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup{
      capabilities = capabilities
    }
  end
  nvim_lsp.jdtls.setup{ cmd = { 'jdtls' } }
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

  require('cmp_tabnine.config'):setup({
    max_lines = 1000;
    max_num_results = 20;
    sort = true;
  })

  local cmp = require('cmp')
  local luasnip = require('luasnip')
  cmp.setup {
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = require('lspkind').presets.default[vim_item.kind]
            .. ' ' .. vim_item.kind
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
      end
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