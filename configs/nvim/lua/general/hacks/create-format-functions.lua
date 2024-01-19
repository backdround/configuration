local function create_format_functions(client_id)
  local file_format = function()
    vim.lsp.buf.format({ id = client_id })
  end

  local operator_format = function()
    local uniq_format_function_name = "user_defined_make_format"
      .. tostring(client_id)

    -- selene: allow(global_usage)
    -- Creates uniq global format function
    if not _G[uniq_format_function_name] then
      _G[uniq_format_function_name] = function()
        local start = vim.api.nvim_buf_get_mark(0, "[")
        local finish = vim.api.nvim_buf_get_mark(0, "]")
        vim.lsp.buf.format({
          id = client_id,
          range = {
            ["start"] = start,
            ["end"] = finish,
          },
        })
      end
    end

    -- Perform formatting.
    vim.go.operatorfunc = "v:lua." .. uniq_format_function_name
    vim.api.nvim_feedkeys("g@", "n", false)
  end

  return {
    file = file_format,
    operator = operator_format,
  }
end

return create_format_functions
