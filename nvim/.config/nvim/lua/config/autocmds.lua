local augroup = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
    if ok and parser then
      pcall(vim.treesitter.start, args.buf)
    end
  end,
  desc = "Start treesitter highlighting when a parser is available",
})