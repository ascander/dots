local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok then
	return
end

local logo = {
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                                                              ]],
        [[                                    ██████                                    ]],
        [[                                ████▒▒▒▒▒▒████                                ]],
        [[                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ]],
        [[                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ]],
        [[                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ]],
        [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ]],
        [[                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ]],
        [[                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ]],
        [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
        [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
        [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
        [[                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ]],
        [[                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ]],
        [[                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ]],
        [[                        ██      ██      ████      ████                        ]],
        [[                                                                              ]],
        [[                                                                              ]],
      }

local opts = {
	theme = "doom",
	hide = {
		statusline = false,
	},
	config = {
		header = logo,
		center = {
		  { action = "Telescope find_files",                 desc = " Find File",       icon = " ", key = "f" },
		  { action = "ene | startinsert",                    desc = " New File",        icon = " ", key = "n" },
		  { action = "Telescope oldfiles",                   desc = " Recent Files",    icon = " ", key = "r" },
		  { action = "Telescope live_grep",                  desc = " Find Text",       icon = " ", key = "g" },
		  { action = "e ~/.config/nvim",                     desc = " Config",          icon = " ", key = "c" },
		  -- { action = 'lua require("persistence").load()',    desc = " Restore Session", icon = " ", key = "s" },
		  { action = "qa",                                   desc = " Quit",            icon = " ", key = "q" },
		},
		footer = { "It is a foolish dog that barks at flying birds." },
	}

}

dashboard.setup(opts)
