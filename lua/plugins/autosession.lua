return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    auto_restore = true,
  },
  keys = {
    { '<leader>wr', '<cmd>AutoSession search<CR>', desc = 'Session search' },
    { '<leader>ws', '<cmd>AutoSession save<CR>', desc = 'Save session' },
    { '<leader>wa', '<cmd>AutoSession toggle<CR>', desc = 'Toggle session autosave' },
  }
}
