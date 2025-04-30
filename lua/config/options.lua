vim.opt.clipboard = ""
vim.opt.undofile = true
if vim.fn.has("win32") == 1 then
  vim.opt.undodir = os.getenv("USERPROFILE") .. "/AppData/Local/nvim/undo/"
  vim.opt.shell = "pwsh"
end
vim.opt.wrap = true
vim.opt.scrolloff = 12
vim.opt.sessionoptions:remove("blank") -- Don't save empty windows in session (can cause issues with neo-tree)

vim.g.indent_blankline_show_current_context = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars:append("trail:·")

vim.opt.timeoutlen = 250
vim.opt.updatetime = 50

vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer

vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.fillchars:append({ eob = " " })
-- vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- Global settings (tab = 2 spaces)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Python-specific settings (tab = 4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  end,
})
