return {
	{
		-- dummy plugin spec just to run config
		-- (you can name anything or use a real plugin; this is common)
		"nvim-lua/plenary.nvim",
		lazy = true,
		config = function()
			local function autosave()
				local bufnr = vim.api.nvim_get_current_buf()

				if vim.bo.modified and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
					-- If you want autosave to NOT format, just keep update:
					vim.cmd("silent! update")
				end
			end

			-- Save when leaving insert mode
			vim.api.nvim_create_autocmd("InsertLeave", {
				desc = "Autosave on InsertLeave",
				callback = function()
					vim.schedule(autosave)
				end,
			})

			-- Save when leaving Neovim window
			vim.api.nvim_create_autocmd("FocusLost", {
				desc = "Autosave on FocusLost",
				callback = function()
					vim.schedule(autosave)
				end,
			})

			-- fold refresh
			-- vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
			-- 	callback = function()
			-- 		vim.cmd("silent! normal! zX")
			-- 	end,
			-- })
		end,
	},
}
