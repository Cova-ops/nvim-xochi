-- Runner genérico para proyectos Rust / JS / Python
-- Comandos:
--   :Run [cmd]     -> ejecuta cmd o lo detecta por proyecto (prioriza dev.sh/run.sh)
--   :RunStop       -> mata el proceso actual
--   :Build         -> build por proyecto
--   :Test          -> tests por proyecto
--
--   Trying to find this files:
--   scripts/nvim_run.sh
--   scripts/nvim_test.sh
--   scripts/nvim_build.sh

local M = {}
M.state = { term_buf = nil, term_win = nil, job_id = nil, last_cmd = nil }

-- ---------- Helpers --------
local function percent_height(pct)
	return math.max(8, math.floor(vim.o.lines * pct))
end

local RUN_HEIGHT = percent_height(0.60)

-- ---------- Utils ----------
local function exists(path)
	return vim.loop.fs_stat(path) ~= nil
end
local function root_dir()
	-- 1) git, 2) markers, 3) cwd
	local git = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if git and git ~= "" and vim.v.shell_error == 0 then
		return git
	end
	local cwd = vim.loop.cwd()
	local markers = {
		"Cargo.toml",
		"package.json",
		"pyproject.toml",
		"requirements.txt",
		"scripts/nvim_run.sh",
		"scripts/nvim_test.sh",
		"scripts/nvim_build.sh",
	}
	for _, m in ipairs(markers) do
		if exists(cwd .. "/" .. m) then
			return cwd
		end
	end
	return cwd
end

local function ensure_term_win()
	if M.state.term_win and vim.api.nvim_win_is_valid(M.state.term_win) then
		-- asegura que tenga la altura deseada
		pcall(vim.api.nvim_win_set_height, M.state.term_win, RUN_HEIGHT)
		return
	end
	vim.cmd("botright split")
	M.state.term_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(M.state.term_win, RUN_HEIGHT)
end

local function close_term_win()
	if M.state.term_win and vim.api.nvim_win_is_valid(M.state.term_win) then
		pcall(vim.api.nvim_win_close, M.state.term_win, true)
	end
	M.state.term_win = nil
	M.state.term_buf = nil
end

local function stop_job()
	if M.state.job_id and vim.fn.jobwait({ M.state.job_id }, 0)[1] == -1 then
		pcall(vim.fn.jobstop, M.state.job_id)
	end
	M.state.job_id = nil
end

local function run_cmd(cmd)
	ensure_term_win()
	stop_job()

	local cwd = root_dir()

	-- crea buffer NUEVO (aún sin terminal) y colócalo en la ventana
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(M.state.term_win, buf)
	M.state.term_buf = buf
	vim.bo[buf].bufhidden = "wipe"

	-- helper para agregar líneas a un terminal (temporalmente modifiable)
	local function append(lines)
		if vim.api.nvim_buf_is_valid(buf) then
			local prev = vim.bo[buf].modifiable
			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
			vim.bo[buf].modifiable = prev
		end
	end

	M.state.job_id = vim.fn.termopen(cmd, {
		cwd = cwd,
		on_exit = function(_, code, _)
			vim.schedule(function()
				append({ "", ("[exit %d] %s"):format(code, cmd) })
				M.state.job_id = nil
			end)
		end,
	})

	vim.cmd("normal! G")
	M.state.last_cmd = cmd
end
---------- Detección de comando ----------
local function read_json(path)
	local ok, data = pcall(function()
		local content = table.concat(vim.fn.readfile(path), "\n")
		return vim.fn.json_decode(content)
	end)
	return ok and data or nil
end

local function detect_script(cwd, type)
	-- prioridad a scripts del repo
	local candidates = {}

	if type == "run" then
		candidates = { "scripts/nvim_run.sh" }
	end
	if type == "test" then
		candidates = { "scripts/nvim_test.sh" }
	end
	if type == "build" then
		candidates = { "scripts/nvim_build.sh" }
	end

	for _, s in ipairs(candidates) do
		local p = cwd .. "/" .. s
		if exists(p) then
			-- asegúrate que sea ejecutable (si no, lánzalo vía bash)
			if vim.fn.executable(p) == 1 then
				return "./" .. s
			else
				return "bash " .. s
			end
		end
	end
	return nil
end

local function detect_project(cwd)
	local is_rust = exists(cwd .. "/Cargo.toml")
	local is_node = exists(cwd .. "/package.json")
	local is_py = exists(cwd .. "/pyproject.toml") or exists(cwd .. "/requirements.txt")
	return { rust = is_rust, node = is_node, py = is_py }
end

local function find_main_py(cwd)
	-- heurística mínima para Python
	local candidates = { "main.py", "app.py" }
	for _, f in ipairs(candidates) do
		if exists(cwd .. "/" .. f) then
			return f
		end
	end
	return nil
end

local function detect_run_cmd(cwd)
	-- 1) si hay script estándar, úsalo
	local script = detect_script(cwd, "run")
	if script then
		return script
	end

	-- 2) por lenguaje
	local proj = detect_project(cwd)
	if proj.rust then
		return "cargo run"
	elseif proj.node then
		local pkg = read_json(cwd .. "/package.json") or {}
		local scripts = pkg.scripts or {}
		return scripts.dev and "npm run dev" or scripts.start and "npm start" or "node ." -- fallback
	elseif proj.py then
		local use_poetry = exists(cwd .. "/poetry.lock")
			or (
				exists(cwd .. "/pyproject.toml")
				and (vim.fn.system('grep -q "\\[tool.poetry\\]" pyproject.toml; echo $?') == "0\n")
			)
		local main = find_main_py(cwd)
		if use_poetry then
			return main and ("poetry run python " .. main) or "poetry run python -m pip --version"
		else
			return main and ("python " .. main) or "python -V"
		end
	end

	-- 3) fallback
	return 'bash -lc "echo No se pudo detectar comando de ejecución; usa :Run <cmd>"'
end

local function detect_build_cmd(cwd)
	-- 1) si hay script estándar, úsalo
	local script = detect_script(cwd, "build")
	if script then
		return script
	end

	-- 2) por lenguaje
	local proj = detect_project(cwd)
	if proj.rust then
		return "cargo build"
	end
	if proj.node then
		local pkg = read_json(cwd .. "/package.json") or {}
		local s = pkg.scripts or {}
		return s.build and "npm run build" or "npm pack"
	end
	if proj.py then
		if exists(cwd .. "/pyproject.toml") then
			return "python -m build"
		end
		return 'echo "Sin build definido para Python"'
	end
	return 'echo "Sin build detectado"'
end

local function detect_test_cmd(cwd)
	-- 1) si hay script estándar, úsalo
	local script = detect_script(cwd, "test")
	if script then
		return script
	end

	-- 2) por lenguaje
	local proj = detect_project(cwd)
	if proj.rust then
		return "cargo test"
	end
	if proj.node then
		local pkg = read_json(cwd .. "/package.json") or {}
		local s = pkg.scripts or {}
		return s.test and "npm test" or 'echo "No hay script test en package.json"'
	end
	if proj.py then
		if exists(cwd .. "/pytest.ini") or exists(cwd .. "/pyproject.toml") then
			return "pytest -q"
		end
		return "python -m unittest -q"
	end
	return 'echo "Sin tests detectados"'
end

-- ---------- Comandos ----------
vim.api.nvim_create_user_command("Run", function(opts)
	local cwd = root_dir()
	local cmd = (opts.args ~= "" and opts.args) or detect_run_cmd(cwd)
	run_cmd(cmd)
end, { nargs = "*", complete = "shellcmd" })

vim.api.nvim_create_user_command("RunStop", function()
	-- mata el job si sigue vivo
	if M.state.job_id and vim.fn.jobwait({ M.state.job_id }, 0)[1] == -1 then
		pcall(vim.fn.jobstop, M.state.job_id)
		M.state.job_id = nil
	end
	-- cierra el split/terminal
	close_term_win()
end, {})

vim.api.nvim_create_user_command("Build", function()
	local cmd = detect_build_cmd(root_dir())
	run_cmd(cmd)
end, {})

vim.api.nvim_create_user_command("Test", function()
	local cmd = detect_test_cmd(root_dir())
	run_cmd(cmd)
end, {})

-- Atajos opcionales
vim.keymap.set("n", "<leader>rr", function()
	vim.cmd("Run")
end, { desc = "Run Project" })
vim.keymap.set("n", "<leader>rs", function()
	vim.cmd("RunStop")
end, { desc = "Run Stop" })
vim.keymap.set("n", "<leader>rb", function()
	vim.cmd("Build")
end, { desc = "Build Project" })
vim.keymap.set("n", "<leader>rt", function()
	vim.cmd("Test")
end, { desc = "Test Project" })

return M
