local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	commit = "9637670896b68805430e2f72cf5d16be5b97a22a",
	main = "ibl",
}

function M.config()
	local icons = require("user.icons")

	require("ibl").setup({
		indent = { char = icons.ui.LineMiddle },
		whitespace = {
			remove_blankline_trail = true,
		},

		exclude = {
			filetypes = {
				"help",
				"startify",
				"dashboard",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"Trouble",
				"text",
			},
			buftypes = { "terminal", "nofile" },
		},
		scope = { enabled = false },
	})
end

return M
