return {
	{
		"mrcjkb/rustaceanvim",
		opts = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							buildScripts = { enable = true },
							loadOutDirsFromCheck = true,
						},
						check = {
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
						checkOnSave = true,
						diagnostics = {
							enable = true,
							disabled = { "unlinked-file" },
						},
						files = {
							exclude = {
								".direnv",
								".git",
								".jj",
								".github",
								".gitlab",
								"bin",
								"node_modules",
								"target",
								"venv",
								".venv",
							},
							watcher = "client",
						},
						procMacro = { enable = true },
					},
				},
			},
		},
	},
}
