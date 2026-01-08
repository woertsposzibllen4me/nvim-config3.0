-- General settings for LSPs / overall diagnostics config
local M = {}

-- General diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    show_header = true,
    source = "if_many",
    border = "rounded",
  },
})

-- Save after sucessful global renames to avoid issues with unsaved symbol names resetting upon sequential lsp renames
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    local original_rename_handler = vim.lsp.handlers["textDocument/rename"]

    -- Override handler to save after successful rename
    vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
      original_rename_handler(err, result, ctx, config)
      if result and (result.changes or result.documentChanges) then
        vim.defer_fn(function()
          vim.cmd("silent! wa")
        end, 0)
      end
    end
  end,
})

function M.setup_diagnostic_jumps()
  if M.next_diag then
    return M.next_diag, M.prev_diag, M.next_error, M.prev_error
  end

  -- Regular diagnostic jumps
  local function next_diag()
    vim.diagnostic.jump({ count = vim.v.count1, float = true })
  end

  local function prev_diag()
    vim.diagnostic.jump({ count = -vim.v.count1, float = true })
  end

  -- Error-only diagnostic jumps
  local function next_error()
    vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
  end

  local function prev_error()
    vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
  end

  M.next_diag, M.prev_diag = RepeatablePairs.track_pair(next_diag, prev_diag)
  M.next_error, M.prev_error = RepeatablePairs.track_pair(next_error, prev_error)

  return M.next_diag, M.prev_diag, M.next_error, M.prev_error
end

-- LSP keymaps
local next_diag, prev_diag, next_error, prev_error = M.setup_diagnostic_jumps()
vim.keymap.set("n", "]d", next_diag)
vim.keymap.set("n", "[d", prev_diag)
vim.keymap.set("n", "]D", next_error)
vim.keymap.set("n", "[D", prev_error)

vim.keymap.set("n", "<leader>xl", function()
  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end, { desc = "Toggle line diagnostics" })

vim.keymap.set("n", "<leader>xu", function()
  vim.diagnostic.config({
    underline = not vim.diagnostic.config().underline,
  })
end, { desc = "Toggle diagnostics underlines" })

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Lsp Hover Info" })

vim.keymap.set("n", "<space>ca", function()
  vim.lsp.buf.code_action({
    filter = M.code_action_filter,
  })
end, { desc = "code action (filtered)" })

vim.keymap.set("n", "<space>cA", function()
  vim.lsp.buf.code_action()
end, { desc = "code action (all)" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol under cursor" })
vim.keymap.set("n", "go", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })

M.code_action_filter = function(action)
  local title = action.title:lower()

  -- Filter out ruff auto-fix actions
  local ruff_exclusions = {
    "ruff.*fix all",
    "ruff.*organize imports",
    "fix all.*ruff",
    "organize imports.*ruff",
  }

  for _, pattern in ipairs(ruff_exclusions) do
    if string.match(title, pattern) then
      return false
    end
  end

  return true
end

-- pylsp configuration
M.pylsp = {
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = false },
        rope_rename = { enabled = false }, -- doesnt seem to do anything useful lmfao
        mccabe = { enabled = false },
        jedi_completion = { enabled = false },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = false },
        jedi_signature_help = { enabled = false },
        jedi_symbols = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        rope_completion = { enabled = false },
        ruff = { enabled = false },
      },
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.renameProvider = true
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.hoverProvider = nil
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.documentHighlightProvider = nil
    client.server_capabilities.documentSymbolProvider = nil
    client.server_capabilities.workspaceSymbolProvider = nil
    client.server_capabilities.codeActionProvider = nil
    client.server_capabilities.codeLensProvider = nil
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
    client.server_capabilities.documentOnTypeFormattingProvider = nil
    client.server_capabilities.executeCommandProvider = nil
  end,
}
return M
