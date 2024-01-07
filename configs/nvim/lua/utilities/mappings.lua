local M = {}

M._hijack_set_keymap = function()
  M._nvim_set_keymap = vim.api.nvim_set_keymap
  M._vim_keymap_set = vim.keymap.set

  vim.api.nvim_set_keymap = function() end
  vim.keymap.set = function(mode, lhs, rhs, opts)
    local plug = lhs:find("<plug>") ~= nil or lhs:find("<Plug>") ~= nil
    if opts and opts.buffer or plug then
      M._perform_keymap_set(mode, lhs, rhs)
    end
  end

  M._perform_keymap_set = function(...)
    vim.api.nvim_set_keymap = M._nvim_set_keymap
    M._vim_keymap_set(unpack({ ... }))
    vim.api.nvim_set_keymap = function() end
  end
end

M.init = function()
  if M._inited then
    return
  end
  M._inited = true

  vim.keymap.del({ "n", "x" }, "gx")
  M._hijack_set_keymap()
end

M.full_featured_map = function(mode, lhs, rhs, options_or_desc)
  local options = {}
  if type(options_or_desc) == "table" then
    options = options_or_desc
  elseif type(options_or_desc) == "string" then
    options.desc = options_or_desc
  end

  if not options.desc then
    print("There is no description for the mapping: " .. lhs)
    print("Please add it!")
  end

  local default = {
    silent = true,
    noremap = true,
  }
  options = vim.tbl_extend("force", default, options)

  M._perform_keymap_set(mode, lhs, rhs, options)
end

M.map = function(lhs, rhs, options)
  M.full_featured_map({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s", "l" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(lhs, rhs, options)
    M.full_featured_map(mode, lhs, rhs, options)
  end
end

return M
