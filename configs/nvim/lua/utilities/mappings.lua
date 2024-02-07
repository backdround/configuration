local assert_types = require("utilities.assert-types")
local new_logger = require("utilities.logger").new
local M = {}

---Hijacks vim.set.keymap and vim.api.nvim_set_keymap functions.
---It allows to map only buffer-local, <plug> or mappings from allowed_sources.
---Also logs all prohibited attempts.
M._hijack_keymap_setting_api_functions = function()
  local create_keymap_setting_wrapper = function(keymap_setting_function)
    return function(mode, lhs, rhs, options)
      local is_allowed = function()
        local caller = debug.getinfo(3, "S")
        for _, allowed_source in ipairs(M._allowed_sources) do
          if caller.source:find(allowed_source, 1, true) ~= nil then
            return true
          end
        end
        return false
      end

      local pass_through = false
        or (options and options.buffer ~= nil)
        or (lhs:find("<plug>") ~= nil or lhs:find("<Plug>") ~= nil)
        or is_allowed()

      if pass_through then
        keymap_setting_function(mode, lhs, rhs, options)
        return
      end

      M._logger:log(vim.inspect({
        caller = debug.getinfo(2, "S"),
        mode = mode,
        lhs = lhs,
        rhs = rhs,
        opts = options,
      }))
    end
  end

  M._real_nvim_set_keymap = vim.api.nvim_set_keymap
  M._real_vim_keymap_set = vim.keymap.set

  vim.api.nvim_set_keymap = create_keymap_setting_wrapper(function(...)
    M._real_nvim_set_keymap(...)
  end)

  vim.keymap.set = create_keymap_setting_wrapper(function(...)
    local saved_nvim_set_keymap = vim.api.nvim_set_keymap
    vim.api.nvim_set_keymap = M._real_nvim_set_keymap
    M._real_vim_keymap_set(...)
    vim.api.nvim_set_keymap = saved_nvim_set_keymap
  end)
end

M.init = function()
  if M._inited then
    return
  end
  M._inited = true

  vim.keymap.del({ "n", "x" }, "gx")

  M._logger = new_logger("mappings.log", true)
  vim.api.nvim_create_user_command("MappingsLog", function()
    local log = M._logger:get()
    -- selene: allow(global_usage)
    _G.ui_inspect(log)
  end, {})

  M._hijack_keymap_setting_api_functions()
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
  assert_types({
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
  }
  options = vim.tbl_extend("force", default, options)

  -- Perform vim.keymap.set.
  local saved_nvim_set_keymap = vim.api.nvim_set_keymap
  vim.api.nvim_set_keymap = M._real_nvim_set_keymap
  M._real_vim_keymap_set(mode, lhs, rhs, options)
  vim.api.nvim_set_keymap = saved_nvim_set_keymap
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
