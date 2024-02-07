local new_logger = require("utilities.logger").new
local M = {
  _allowed_sources = {},
}

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

---Adds a source from which attempts to map should be allowed
---@param source string any part of the source path
M.allow_mappings_from = function(source)
  if vim.tbl_contains(M._allowed_sources, source) then
    return
  end
  table.insert(M._allowed_sources, source)
end

---Prohibits external mappings with vim's api functions.
M.prohibit_external_mappings = function()
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

---Bypasses mappings prohibition and performs real map with vim.keymap.set.
M.perform_real_vim_keymap_set = function(...)
  local saved_nvim_set_keymap = vim.api.nvim_set_keymap
  vim.api.nvim_set_keymap = M._real_nvim_set_keymap
  M._real_vim_keymap_set(...)
  vim.api.nvim_set_keymap = saved_nvim_set_keymap
end

return M
