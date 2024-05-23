local M = {
	"alexghergh/nvim-tmux-navigation",
	event = "VeryLazy",
}

function M.config()
	local wk = require("which-key")
	wk.register({
		["<C-h>"] = { "<cmd>NvimTmuxNavigateLeft<cr>", "Navigate Left" },
		["<C-j>"] = { "<cmd>NvimTmuxNavigateDown<cr>", "Navigate Down" },
		["<C-k>"] = { "<cmd>NvimTmuxNavigateUp<cr>", "Navigate Up" },
		["<C-l>"] = { "<cmd>NvimTmuxNavigateRight<cr>", "Navigate Right" },
		["<C-\\>"] = { "<cmd>NvimTmuxNavigateLastActive<cr>", "Navigate Last Active" },
		["<C-Space>"] = { "<cmd>NvimTmuxNavigateNext<cr>", "Navigate Next" },
	})

	require("nvim-tmux-navigation").setup({})
end

return M
