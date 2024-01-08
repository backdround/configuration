local M = {}

---Hijacks vim.set.keymap and allows only buffer-local, <plug> or own mappings.
---Also logs all attempts to mappings.log
M._hijack_set_keymap = function()
  M._nvim_set_keymap = vim.api.nvim_set_keymap
  M._vim_keymap_set = vim.keymap.set

  vim.api.nvim_set_keymap = function() end
  vim.keymap.set = function(mode, lhs, rhs, opts)
    local plug_mapping = lhs:find("<plug>") ~= nil or lhs:find("<Plug>") ~= nil
    local buffer_mapping = opts and opts.buffer
    local own_mapping = opts and opts.own

    if opts then
      opts.own = nil
    end

    if buffer_mapping or plug_mapping or own_mapping then
      vim.api.nvim_set_keymap = M._nvim_set_keymap
      M._vim_keymap_set(mode, lhs, rhs, opts)
      vim.api.nvim_set_keymap = function() end
      return
    end

    M._log(vim.inspect({ mode = mode, lhs = lhs, rhs = rhs, opts = opts }))
  end
end

---@param entry string
M._log = function(entry)
  local log_file = io.open(M._log_file, "a")
  if log_file == nil then
    return
  end
  log_file:write(entry .. "\n\n")
  io.close(log_file)
end

M.init = function()
  if M._inited then
    return
  end
  M._inited = true

  vim.keymap.del({ "n", "x" }, "gx")

  M._log_file = vim.fn.stdpath("log") .. "/mappings.log"
  os.remove(M._log_file)

  M._hijack_set_keymap()
end

M.adapted_map = function(mode, lhs, rhs, options_or_desc)
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
    own = true,
  }
  options = vim.tbl_extend("force", default, options)

  vim.keymap.set(mode, lhs, rhs, options)
end

M.map = function(lhs, rhs, options)
  M.adapted_map({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s", "l" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(lhs, rhs, options)
    M.adapted_map(mode, lhs, rhs, options)
  end
end

return M
