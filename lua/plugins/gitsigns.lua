-- lazy.nvim plugin spec. Requires Git and a Neovim version supported by the plugins.
-- Install the lazygit executable separately to use ;g.

local function git(cwd, ...)
  return vim.system({ "git", ... }, { cwd = cwd, text = true }):wait()
end

local function stage_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or vim.bo.buftype ~= "" then
    return
  end

  local cwd = vim.fs.dirname(file)
  local status = git(cwd, "status", "--porcelain=v1", "--", file)
  if status.code ~= 0 then
    vim.notify(vim.trim(status.stderr), vim.log.levels.ERROR)
    return
  end
  if status.stdout == "" then
    return
  end

  local unstaged = status.stdout:sub(2, 2)
  local result
  if unstaged == " " then
    result = git(cwd, "reset", "--", file)
  else
    result = git(cwd, "add", "--", file)
  end
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
  end
end

local function open_blame_revision()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or vim.bo.buftype ~= "" then
    return
  end
  if vim.bo.modified then
    vim.notify("Save the file before opening its blame revision.")
    return
  end

  local cwd = vim.fs.dirname(file)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local blame = git(cwd, "blame", "--porcelain", "-L", line .. "," .. line, "--", file)
  local commit, original_line = blame.stdout:match("^(%x+) (%d+)")
  if blame.code ~= 0 or not commit or commit:match("^0+$") then
    vim.notify("No commit found for this line.", vim.log.levels.WARN)
    return
  end

  local root = git(cwd, "rev-parse", "--show-toplevel")
  -- Git parses the filename from its own porcelain output, including rename history.
  local revision = blame.stdout:match("\nfilename ([^\n]+)")
  if root.code ~= 0 or not revision then
    return
  end
  if revision:sub(1, 1) == '"' then
    revision = revision:sub(2, -2):gsub("\\([0-7][0-7][0-7])", function(octal)
      return string.char(tonumber(octal, 8))
    end):gsub('\\(["\\])', "%1")
  end

  local snapshot = git(vim.trim(root.stdout), "show", commit .. ":" .. revision)
  if snapshot.code ~= 0 then
    vim.notify(vim.trim(snapshot.stderr), vim.log.levels.ERROR)
    return
  end

  local filetype = vim.bo.filetype
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(snapshot.stdout, "\n", { plain = true }))
  vim.bo[buf].filetype = filetype
  vim.bo[buf].modifiable = false

  vim.api.nvim_win_set_cursor(0, { math.min(tonumber(original_line) or 1, vim.api.nvim_buf_line_count(buf)), 0 })
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Git blame line")
        map("<leader>gB", gs.blame, "Git blame file")
        map("<leader>go", open_blame_revision, "Open blamed revision")
        map("<leader>gs", stage_file, "Stage or unstage file")
        map("<leader>gh", gs.stage_hunk, "Stage or unstage hunk")
      end,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 1000,
		},
    },
  },
  {
    "craftzdog/mini.diff",
    branch = "feat/grouping",
    main = "mini.diff",
    opts = {
      -- Gitsigns owns the visible gutter markers.
      view = { style = "sign", signs = { add = " ", change = " ", delete = " " }, priority = 1 },
    },
    keys = {
      { "<leader>do", function() require("mini.diff").toggle_overlay(0) end, desc = "Toggle inline diff" },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {},
    keys = {
      { "<leader>dv", "<cmd>CodeDiff<cr>", desc = "Open side-by-side diff" },
      { "<leader>dh", "<cmd>CodeDiff history %<cr>", desc = "Git file history" },
      { "<leader>dH", "<cmd>CodeDiff history<cr>", desc = "Git repository history" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = { lazygit = { enabled = true } },
    keys = {
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Open Lazygit" },
    },
  },
}
