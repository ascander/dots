-- Mini.ai
-- See https://github.com/echasnovski/mini.ai
local status_ok, ai = pcall(require, "mini.ai")
if not status_ok then
	return
end

local mini_ai_opts = {
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}, {}),
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
		t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
		d = { "%f[%d]%d+" }, -- digits
		e = { -- Word with case
			{
				"%u[%l%d]+%f[^%l%d]",
				"%f[%S][%l%d]+%f[^%l%d]",
				"%f[%P][%l%d]+%f[^%l%d]",
				"^[%l%d]+%f[^%l%d]",
			},
			"^().*()$",
		},
		g = function() -- Whole buffer, similar to `gg` and 'G' motion
			local from = { line = 1, col = 1 }
			local to = {
				line = vim.fn.line("$"),
				col = math.max(vim.fn.getline("$"):len(), 1),
			}
			return { from = from, to = to }
		end,
		u = ai.gen_spec.function_call(), -- u for "Usage"
		U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
	},
}

ai.setup(mini_ai_opts)

-- Mini.align
-- See https://github.com/echasnovski/mini.align
local status_ok, align = pcall(require, "mini.align")
if not status_ok then
	return
end

align.setup {}

-- Mini.indentscope
-- See https://github.com/echasnovski/mini.indentscope
local status_ok, indentscope = pcall(require, "mini.indentscope")
if not status_ok then
	return
end

indentscope.setup {
	symbol = "│",
	options = { try_as_border = true },
}

-- Mini.pairs
-- See https://github.com/echasnovski/mini.pairs
local status_ok, pairs = pcall(require, "mini.pairs")
if not status_ok then
	return
end

pairs.setup {
	mappings = {
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false }}
	},
}

-- Mini.surround
-- See https://github.com/echasnovski/mini.surround
local status_ok, surround = pcall(require, "mini.surround")
if not status_ok then
	return
end

surround.setup {
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`
	},
}

