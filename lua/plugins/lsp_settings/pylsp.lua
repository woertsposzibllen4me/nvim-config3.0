local M = {}

M.settings = {
  pylsp = {
    plugins = {
      -- Enabled plugins
      pylint = { enabled = true },
      mccabe = { enabled = true },
      rope_rename = { enabled = true },
      -- Explicitly disabled plugins
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
}

function M.on_attach(client, _)
  -- Enable only specific capabilities
  client.server_capabilities.renameProvider = true
  -- Disable all other capabilities
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
end

return M
