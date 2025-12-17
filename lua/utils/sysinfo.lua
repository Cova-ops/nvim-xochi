local uv = vim.uv or vim.loop

local M = {}

local ICONS = {
	cpu = "",
	ram = "󰍛",
}

local TH = { ok = 40, warn = 70 }

local state = {
	cpu = nil,
	ram = nil,
	cpu_group = "SysInfoDim",
	ram_group = "SysInfoDim",
}

local last_total, last_idle
local timer

local function pick_group(p)
	if not p then
		return "SysInfoDim"
	end
	if p >= TH.warn then
		return "SysInfoHigh"
	end
	if p >= TH.ok then
		return "SysInfoWarn"
	end
	return "SysInfoOk"
end

local function read_cpu_percent()
	local infos = uv.cpu_info()
	if not infos then
		return nil
	end

	local total, idle = 0, 0
	for _, core in ipairs(infos) do
		local t = core.times
		idle = idle + (t.idle or 0)
		total = total + (t.user or 0) + (t.nice or 0) + (t.sys or 0) + (t.idle or 0) + (t.irq or 0)
	end

	if not last_total or not last_idle then
		last_total, last_idle = total, idle
		return nil
	end

	local d_total = total - last_total
	local d_idle = idle - last_idle
	last_total, last_idle = total, idle

	if d_total <= 0 then
		return nil
	end
	return math.floor((1 - (d_idle / d_total)) * 100 + 0.5)
end

local function read_ram_percent()
	local free = uv.get_free_memory()
	local total = uv.get_total_memory()
	if not free or not total or total == 0 then
		return nil
	end
	return math.floor(((total - free) / total) * 100 + 0.5)
end

local function ram_percent_macos()
	local out = vim.fn.systemlist("vm_stat")
	if vim.v.shell_error ~= 0 or not out or #out == 0 then
		return nil
	end

	local page_size = tonumber((out[1] or ""):match("page size of (%d+) bytes")) or 4096

	local function pages(key)
		for _, line in ipairs(out) do
			if line:find(key, 1, true) then
				local n = tonumber(line:match("(%d+)")) or 0
				return n
			end
		end
		return 0
	end

	local free = pages("Pages free")
	local speculative = pages("Pages speculative")
	local inactive = pages("Pages inactive")
	local active = pages("Pages active")
	local wired = pages("Pages wired down")
	local compressed = pages("Pages occupied by compressor")

	local total_pages = free + speculative + inactive + active + wired + compressed
	if total_pages == 0 then
		return nil
	end

	-- “Used” más cercano a realidad (sin contar cache como 100% usado)
	local used_pages = active + wired + compressed

	return math.floor((used_pages / total_pages) * 100 + 0.5)
end

local function hl_fg_hex(group)
	-- obtiene el color real (fg) del colorscheme, aunque sea link
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = true })
	if not ok or not hl or not hl.fg then
		return nil
	end
	return string.format("#%06x", hl.fg)
end

local function update()
	local cpu = read_cpu_percent()
	local ram = read_ram_percent()

	state.cpu = cpu
	state.ram = ram
	state.cpu_group = pick_group(cpu)
	state.ram_group = pick_group(ram)
end

function M.setup(opts)
	opts = opts or {}
	local interval = opts.interval_ms or 1500

	if timer then
		return
	end
	timer = uv.new_timer()

	-- primera lectura (RAM sí, CPU quizá aún no)
	update()

	timer:start(0, interval, vim.schedule_wrap(update))
end

-- componentes para lualine
function M.cpu()
	return (state.cpu and (ICONS.cpu .. " " .. state.cpu .. "%")) or (ICONS.cpu .. " --%")
end

function M.ram()
	local p = ram_percent_macos()
	return (p and (ICONS.ram .. " " .. p .. "%")) or (ICONS.ram .. " --%")
end

function M.cpu_color()
	local fg = hl_fg_hex(state.cpu_group)
	if not fg then
		return nil
	end
	return { fg = fg or "#ffffff" }
end

function M.ram_color()
	local fg = hl_fg_hex(state.ram_group)
	if not fg then
		return nil
	end
	return { fg = fg or "#ffffff" }
end

return M
