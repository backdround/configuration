local u = require("utilities.general")
local M = {}

---Hijacks vim.set.keymap and allows only buffer-local, <plug> or own mappings.
---Also logs all attempts to mappings.log
M._hijack_set_keymap = function()
  M._nvim_set_keymap = vim.api.nvim_set_keymap
  M._vim_keymap_set = vim.keymap.set

  vim.api.nvim_set_keymap = function() end
  vim.keymap.set = function(mode, lhs, rhs, opts)

    local is_allowed = function()
      local caller = debug.getinfo(3, "S")
      for _, allowed_source in ipairs(M._allowed_sources) do
        if caller.source:find(allowed_source) ~= nil then
          return true
        end
      end
      return false
    end

    local pass_through = false
      or (opts and opts.buffer ~= nil)
      or (opts and opts.own)
      or (lhs:find("<plug>") ~= nil or lhs:find("<Plug>") ~= nil)
      or is_allowed()

    if opts and opts.own then
      opts.own = nil
    end

    if pass_through then
      vim.api.nvim_set_keymap = M._nvim_set_keymap
      M._vim_keymap_set(mode, lhs, rhs, opts)
      vim.api.nvim_set_keymap = function() end
      return
    end

    M._log(vim.inspect({
      caller = debug.getinfo(3, "S"),
      mode = mode,
      lhs = lhs,
      rhs = rhs,
      opts = opts
    }))
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

M._allowed_sources = {}
M.allow_mapping_from = function(source)
  if vim.tbl_contains(M._allowed_sources, source) then
    return
  end
  table.insert(M._allowed_sources, source)
end

---More convinient wrapper for vim.keymap.set
---@param modes string|table
---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.adapted_map = function(modes, lhs, rhs, options_or_description)
  u.assert_types({
    mode = { modes, "string", "table" },
    lhs = { lhs, "string" },
    rhs = { rhs, "string", "function" },
    options_or_description = { options_or_description, "string", "table" },
  })

  local mode = {}
  if type(modes) == "string" then
    for i = 1, #modes do
      local m = modes:sub(i, i)
      table.insert(mode, m)
    end
  else
    mode = modes
  end

  local options = {}
  if type(options_or_description) == "table" then
    options = options_or_description
  elseif type(options_or_description) == "string" then
    options.desc = options_or_description
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
