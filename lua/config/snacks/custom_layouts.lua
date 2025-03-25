return {
  grep_vertical = {
    layout = {
      box = "vertical",
      width = 0.65,
      min_width = 100,
      height = 0.9,
      border = "none",
      { win = "preview", title = "{preview}", height = 0.5, border = "rounded" }, -- Preview at top
      {
        box = "vertical",
        border = "rounded",
        title = "{title} {live} {flags}",
        title_pos = "center",
        { win = "input", height = 1, border = "bottom" },
        { win = "list", border = "none" },
      },
    },
  },
}
