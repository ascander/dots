return {
  -- vim-startuptime
  -- https://github.com/dstein64/vim-startuptime
  -- Profile Neovim startup time
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
