return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate" },
  config = function()
    local languages = {
      "lua",
      "python",
      "sql",
      "markdown",
      "markdown_inline",
      "bash",
      "vim",
      "vimdoc",
    }
    -- Non-blocking: installs missing parsers in background on first read
    require("nvim-treesitter").install(languages)
  end,
}
