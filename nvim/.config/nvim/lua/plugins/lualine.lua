local function python_env()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path and venv_path ~= "" then
    return " " .. vim.fn.fnamemodify(venv_path, ":t")
  end
  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" then
    buf_dir = vim.fn.getcwd()
  end
  local found = vim.fs.find(".venv", { upward = true, type = "directory", path = buf_dir })
  if found and #found > 0 then
    return " " .. vim.fn.fnamemodify(vim.fn.fnamemodify(found[1], ":h"), ":t")
  end
  return ""
end

local function define_term_hl()
  -- Copy the section (y) background AND foreground so numbers sit in a block
  -- like progress/location (Top). lualine maps y -> b when the theme has no y
  -- (gruvbox), and groups only exist after lualine renders, so try several
  -- names with theme-matching fallbacks.
  local bg, fg
  for _, name in ipairs({ "lualine_y_normal", "lualine_b_normal" }) do
    local hl = vim.api.nvim_get_hl(0, { name = name })
    if hl.bg and not bg then
      bg = hl.bg
    end
    if hl.fg and not fg then
      fg = hl.fg
    end
    if bg and fg then
      break
    end
  end
  bg = bg or "#504945" -- gruvbox section b/lightgray
  fg = fg or "#ebdbb2" -- gruvbox white, same as progress text
  vim.api.nvim_set_hl(0, "TermI3Active", { fg = "#fabd2f", bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "TermI3Inactive", { fg = fg, bg = bg })
end

define_term_hl()

local function current_term_id()
  if vim.bo.buftype ~= "terminal" then
    return nil
  end
  if vim.b.toggle_number then
    return tonumber(vim.b.toggle_number)
  end
  local name = vim.api.nvim_buf_get_name(0)
  local id = name:match("toggleterm#(%d+)")
  if id then
    return tonumber(id)
  end
  return nil
end

local function terms_i3()
  local ok, term_mod = pcall(require, "toggleterm.terminal")
  if not ok then
    return ""
  end
  local ok_all, terms = pcall(term_mod.get_all, true)
  if not ok_all or not terms then
    return ""
  end
  local ids = {}
  for _, t in ipairs(terms) do
    if t and t.id then
      -- include minimized (hidden) too: existence = created, not window open
      table.insert(ids, t.id)
    end
  end
  if #ids == 0 then
    return ""
  end
  table.sort(ids)
  local focused = current_term_id()
  local parts = {}
  for _, id in ipairs(ids) do
    if id == focused then
      table.insert(parts, "%#TermI3Active# " .. id .. " %*")
    else
      table.insert(parts, "%#TermI3Inactive# " .. id .. " %*")
    end
  end
  return table.concat(parts, "")
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("user_termi3_hl", { clear = true }),
  callback = define_term_hl,
  desc = "Redefine terminal i3 highlights",
})

vim.api.nvim_create_autocmd({ "TermOpen", "TermClose", "BufEnter", "TermEnter", "TermLeave", "WinClosed", "BufDelete", "BufWipeout" }, {
  group = vim.api.nvim_create_augroup("user_termi3_refresh", { clear = true }),
  callback = function()
    define_term_hl()
    pcall(require("lualine").refresh)
  end,
  desc = "Refresh lualine on terminal changes",
})

-- Solo colores: misma base gruvbox-material, NORMAL gris -> azul y REPLACE mostaza -> naranja
-- para distinguir N/I de un vistazo. Sin tocar layout, textos ni separadores.
local custom_gruvbox = {
  normal = {
    a = { fg = "#282828", bg = "#7daea3", gui = "bold" },
    b = { fg = "#ddc7a1", bg = "#504945" },
    c = { fg = "#ddc7a1", bg = "#32302f" },
  },
  insert = { a = { fg = "#282828", bg = "#a9b665", gui = "bold" } },
  visual = { a = { fg = "#282828", bg = "#ea6962", gui = "bold" } },
  replace = { a = { fg = "#282828", bg = "#e78a4e", gui = "bold" } },
  command = { a = { fg = "#282828", bg = "#d8a657", gui = "bold" } },
  terminal = { a = { fg = "#282828", bg = "#d3869b", gui = "bold" } },
  inactive = { a = { fg = "#ddc7a1", bg = "#504945" } },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      icons_enabled = true,
      theme = custom_gruvbox,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        { "mode" },
      },
      lualine_b = { "branch" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {
        { "diagnostics", sources = { "nvim_lsp" }, sections = { "error", "warn" } },
        { python_env },
      },
      lualine_y = { { terms_i3, padding = { left = 1, right = 1 } }, "progress" },
      lualine_z = { "location" },
    },
  },
}
