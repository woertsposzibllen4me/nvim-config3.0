return {
    'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      vim.keymap.set('n', '<Space><Space>', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
    }
