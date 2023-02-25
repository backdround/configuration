local u = require("utilities")

local function createFormatFunctions(clientId)
  local fileFormat = function()
    vim.lsp.buf.format({ id = clientId })
  end

  local visualFormat = function()
    vim.lsp.buf.format({ id = clientId })
    u.resetCurrentMode()
  end

  local operatorFormat = function()
    local oldOperator = vim.go.operatorfunc

    function MakeFormat()
      local start = vim.api.nvim_buf_get_mark(0, "[")
      local finish = vim.api.nvim_buf_get_mark(0, "]")
      vim.lsp.buf.format({
        id = clientId,
        range = {
          ["start"] = start,
          ["end"] = finish,
        },
      })
      vim.go.operatorfunc = oldOperator
      MakeFormat = nil
    end

    vim.go.operatorfunc = "v:lua.MakeFormat"
    vim.api.nvim_feedkeys("g@", "n", false)
  end

  return {
    file = fileFormat,
    visual = visualFormat,
    operator = operatorFormat,
  }
end

return createFormatFunctions
