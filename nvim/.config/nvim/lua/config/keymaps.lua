-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>yp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Yank absolute file path" })

vim.keymap.set("n", "<leader>yP", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Yank relative file path" })

-- LSP Keybinds
--vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
--vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
--vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

vim.api.nvim_create_user_command("ObsidianDateLink", "%s#\\v/(\\d{2}\\.\\d{2}\\.\\d{4})]]$#/\\1|\\1]]#e", {})

vim.keymap.set("n", "<leader>dl", "<cmd>ObsidianDateLink<cr>", {
  desc = "Add date aliases to links",
})
