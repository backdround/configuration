local saved_v_count1 = 0

---Operator to join lines without any whitespace.
local join_lines = function()
  local uniq_join_function_name = "User_join_lines"

  saved_v_count1 = vim.v.count1

  -- selene: allow(global_usage)
  if not _G[uniq_join_function_name] then
    _G[uniq_join_function_name] = function()
      local get_range_to_join = function()
        local first_line = vim.api.nvim_buf_get_mark(0, "[")[1]
        local last_line = vim.api.nvim_buf_get_mark(0, "]")[1]

        local count = saved_v_count1
        if last_line - first_line > 0 then
          count = last_line - first_line
        end

        local from = first_line
        local to = first_line + count
        if to > vim.api.nvim_buf_line_count(0) then
          to = vim.api.nvim_buf_line_count(0)
        end

        return from, to
      end

      local from, to = get_range_to_join()
      if from == to then
        return
      end

      local lines = vim.api.nvim_buf_get_lines(0, from - 1, to, true)

      local joined_line = lines[1]
      for i = 2, #lines do
        joined_line = joined_line .. lines[i]:match("^%s*(.*)$")
      end

      vim.api.nvim_buf_set_lines(0, from - 1, to, true, { joined_line })
    end
  end

  -- Perform join lines.
  vim.go.operatorfunc = "v:lua." .. uniq_join_function_name
  vim.api.nvim_feedkeys("g@$", "ni", false)
end

return join_lines
