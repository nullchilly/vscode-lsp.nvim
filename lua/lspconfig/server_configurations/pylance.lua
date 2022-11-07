local util = require("lspconfig.util")

local root_files = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
}

local function organize_imports()
	local params = {
		command = "pylance.organizeimports",
		arguments = { vim.uri_from_bufnr(0) },
	}
	vim.lsp.buf.execute_command(params)
end

local function set_python_path(path)
	local clients = vim.lsp.get_active_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pylance",
	})
	for _, client in ipairs(clients) do
		client.config.settings =
			vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		client.notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

return {
	default_config = {
		cmd = {
			"node",
			vim.fn.expand("~/.vscode/extensions/ms-python.vscode-pylance-*/dist/server.bundle.js", false, true)[1],
			"--stdio",
		},
		filetypes = { "python" },
		single_file_support = true,
		root_dir = util.root_pattern(unpack(root_files)),
		settings = {
			python = {
				analysis = {},
			},
		},
	},
	commands = {
		PylanceOrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
		PylanceSetPythonPath = {
			set_python_path,
			description = "Reconfigure Pylance with the provided python path",
			nargs = 1,
			complete = "file",
		},
	},
	docs = {
		description = [[
https://github.com/microsoft/pylance-release

`pylance`, Fast, feature-rich language support for Python
]],
	},
}