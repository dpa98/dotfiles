return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec", "ToggleTermToggleAll" },
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal float", mode = "n" },
    { "<leader>t1", "<cmd>1ToggleTerm direction=float<CR>", desc = "Terminal 1", mode = "n" },
    { "<leader>t2", "<cmd>2ToggleTerm direction=float<CR>", desc = "Terminal 2", mode = "n" },
    { "<leader>t3", "<cmd>3ToggleTerm direction=float<CR>", desc = "Terminal 3", mode = "n" },
    { "<leader>t4", "<cmd>4ToggleTerm direction=float<CR>", desc = "Terminal 4", mode = "n" },
    { "<leader>t5", "<cmd>5ToggleTerm direction=float<CR>", desc = "Terminal 5", mode = "n" },
    { "<leader>ta", "<cmd>ToggleTermToggleAll<CR>", desc = "Toggle all terminals", mode = "n" },
    {
      "<leader>tx",
      function()
        vim.cmd("ToggleTermToggleAll")
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end,
      desc = "Kill all terminals",
      mode = "n",
    },
  },
  opts = {
    open_mapping = nil,
    direction = "float",
    shade_terminals = true,
    persist_mode = false,
    insert_mappings = false,
    start_in_insert = true,
    persist_size = true,
    shell = vim.o.shell,
    float_opts = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("user_toggleterm", { clear = true }),
      pattern = "term://*",
      callback = function(args)
        local buf_opts = { buffer = args.buf }
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", buf_opts, { desc = "Exit terminal mode" }))
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], vim.tbl_extend("force", buf_opts, { desc = "Window left" }))
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], vim.tbl_extend("force", buf_opts, { desc = "Window down" }))
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], vim.tbl_extend("force", buf_opts, { desc = "Window up" }))
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], vim.tbl_extend("force", buf_opts, { desc = "Window right" }))
      end,
      desc = "Toggleterm terminal keymaps",
    })
  end,
}
