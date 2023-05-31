--[[

Telescope configuration

Plugins:

  telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)
  telescope-fzf-native.nvim (https://github.com/nvim-telescope/telescope-fzf-native.nvim)

See:

  https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions

for available extensions to Telescope.

--]]

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- Configuration
telescope.setup({
  defaults = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
    },
  },
})
telescope.load_extension("fzf")

-- Mappings
vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "List normal mode mappings" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>rg", builtin.live_grep, { desc = "[R]ip[G]rep" })
vim.keymap.set("n", "<leader>cc", builtin.colorscheme, { desc = "[C]hange [C]olorscheme" })
