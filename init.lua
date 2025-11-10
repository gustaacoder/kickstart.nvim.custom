vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ''
vim.opt.showmode = false

vim.wo.wrap = false

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    nbsp = '␣',
    eol = '↩'
}
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 12
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
    desc = 'Open diagnostic [Q]uickfix list'
})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {
    desc = 'Exit terminal mode'
})

vim.keymap.set('n', '<C-q>', '<cmd>NvimTreeToggle<CR>', {desc = 'Toggle File Explorer (Ctrl+b)'})

vim.keymap.set('v', 'j', 'k', {desc = 'Move up in visual mode'})

vim.keymap.set('v', 'k', 'j', {desc = 'Move down in visual mode'})

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {
    desc = 'Move focus to the left window'
})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {
    desc = 'Move focus to the right window'
})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {
    desc = 'Move focus to the lower window'
})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {
    desc = 'Move focus to the upper window'
})
-- Mapeia o atalho Shift + Alt + f (ou Alt + Shift + f) no modo Normal (n)
vim.keymap.set("n", "<S-A-f>", function()
  -- O comando será executado como uma função anônima
  vim.lsp.buf.format()
end, { desc = "Formatar arquivo via LSP" })

vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope oldfiles<CR>', { desc = '[ ] Find Recent Files (MRU)' })
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' })

vim.keymap.set('n', 'k', 'j', { desc = 'Mover para baixo' })
vim.keymap.set('n', 'j', 'k', { desc = 'Mover para cima' })

vim.api.nvim_create_autocmd({"InsertLeave", "BufLeave", "FocusLost"}, {
    pattern = "*",
    command = "silent! write"
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {
        clear = true
    }),
    callback = function()
        vim.highlight.on_yank()
    end
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath}
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'tpope/vim-sleuth',
    'matze/vim-move',
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
    },
    {
        'nvim-tree/nvim-tree.lua',
        version = '*',
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },

        config = function()
            require('nvim-tree').setup {
                view = {
                    width = 30,
                },
                renderer = {
                    icons = {
                        show = {
                            folder = true,
                            file = true,                        },
                    },
                },
                update_focused_file = {
                    enable = true,
                    update_root = true,
                    ignore_list = {},
                },

                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
                git = {
                    enable = true,
                },
            }
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                toggler = {
                    line = '<leader>cc', 
                    block = '<leader>cb', 
                },

                opleader = {
                    line = '<leader>c',
                    block = '<leader>b',
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {}, 
        priority = 1000,
    },
    { "nvim-telescope/telescope.nvim", tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
    require 'plugins.treesitter',
    require 'plugins.lsp',
    require 'plugins.conform',
    require 'plugins.cmp',
    require 'plugins.theme',
    require 'plugins.todo-comments',
    require 'plugins.mini',
    require 'plugins.toggleterm',
    require 'plugins.oil',
    require 'plugins.debug',
    require 'plugins.indent_line',
    require 'plugins.autopairs',
    require 'plugins.harpoon',
    require 'plugins.zen',
    require 'plugins.supermaven',
    require 'plugins.gitsigns',

    -- {
    --   'github/copilot.vim',
    -- },
    -- require 'plugins.comment',
    -- require 'plugins.laravel',
    -- require 'plugins.lint',

    { import = 'custom.plugins' },
}, {
        ui = {
            icons = vim.g.have_nerd_font and {} or {
                cmd = '⌘',
                config = '🛠',
                event = '📅',
                ft = '📂',
                init = '⚙',
                keys = '🗝',
                plugin = '🔌',
                runtime = '💻',
                require = '🌙',
                source = '📄',
                start = '🚀',
                task = '📌',
                lazy = '💤 ',
            },
        },
    })