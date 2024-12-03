vim.opt.clipboard = ""
vim.opt.undofile = true
vim.opt.undodir = os.getenv("USERPROFILE") .. "/AppData/Local/nvim/undo/"
vim.opt.wrap = true
vim.opt.scrolloff = 12

vim.g.indent_blankline_show_current_context = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.listchars:append("trail:·")
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
