return {
  "subnut/nvim-ghost.nvim",
  config = function()
    -- Create the autocommand group if it doesn't exist
    vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = true })

    -- General autocommand for websites only
    vim.api.nvim_create_autocmd("User", {
      group = "nvim_ghost_user_autocommands",
      pattern = "*.*", -- Only match patterns with a domain (containing a dot)
      callback = function()
        local domain = vim.fn.expand("<amatch>")
        -- Make sure we're only handling actual domains
        if string.match(domain, "%.") then
          -- Remove www. prefix if present
          domain = string.gsub(domain, "^www%.", "")
          vim.cmd("file GhostText:" .. domain)
        end
      end,
    })

    -- Site-specific autocommands for setting filetypes
    local markdown_sites = {
      "*github.com",
      "*stackoverflow.com",
      "*reddit.com",
      "*discourse.*",
      "*forum.*",
      "*medium.com",
      "*hashnode.com",
      "*dev.to",
      "*gitlab.com",
    }

    vim.api.nvim_create_autocmd("User", {
      group = "nvim_ghost_user_autocommands",
      pattern = markdown_sites,
      callback = function()
        vim.cmd("setfiletype markdown")
      end,
    })

    -- Add HTML filetype for other common sites
    local html_sites = {
      "*gmail.com",
      "*outlook.com",
      "*mail.google.com",
    }

    vim.api.nvim_create_autocmd("User", {
      group = "nvim_ghost_user_autocommands",
      pattern = html_sites,
      callback = function()
        vim.cmd("setfiletype html")
      end,
    })
  end,
}
