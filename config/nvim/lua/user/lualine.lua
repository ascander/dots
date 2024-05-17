local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

lualine.setup {
	options = {
		always_divide_middle = false,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" }},
		globalstatus = true,
		icons_enabled = true,
		ignore_focus = { "NvimTree" },
		theme = "auto",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{ "filename" },
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 }},
		},
		lualine_x = {},
		lualine_y = {
            		{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 }},
		},
		lualine_z = { 
			function()
				return " " .. os.date("%R")
			end,
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {}
	},
	extensions = { "aerial", "nvim-tree", "quickfix" }
}
