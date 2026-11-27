return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Buscar archivos", mode = "n" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto", mode = "n" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buscar buffers", mode = "n" },
  },
  config = function()
    local themes = require("telescope.themes")
    require("telescope").setup({
      defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        prompt_title = false,
        results_title = false,
        preview_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob",
          "!**/.git/*",
        },
      },
      pickers = {
        find_files = themes.get_dropdown({
          previewer = false,
          prompt_title = false,
          results_title = false,
          preview_title = false,
          hidden = true,
          no_ignore = false,
        }),
        buffers = themes.get_dropdown({
          previewer = false,
          prompt_title = false,
          results_title = false,
          preview_title = false,
        }),
        live_grep = {
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          prompt_title = false,
          results_title = false,
          preview_title = false,
        },
      },
    })
    pcall(require("telescope").load_extension, "fzf")
  end,
}
