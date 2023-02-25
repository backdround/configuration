local vim = {
  s({
    trig = "vimnotify",
    name = "vim notify",
    dscr = "print variable with desktop notification",
  }, fmt('require("utilities").notify(vim.inspect({}))', { i(1) })),

  s({
    trig = "vimout",
    name = "vim out",
    dscr = "print variable with vim.inspect",
  }, fmt("print(vim.inspect({}))", { i(1) })),

  s(
    {
      trig = "vimmod",
      name = "vim lua template module",
      dscr = "create new vim lua template module",
    },
    fmta(
      [[
        local function apply(addPlugin)
          <>
        end

        return {
          apply = apply
        }
      ]],
      { i(1) }
    )
  ),
}

local general = {
  s(
    {
      trig = "out",
      name = "print",
      dscr = "print something",
    },
    fmt("print({value})", {
      value = i(1, "value"),
    })
  ),

  s(
    {
      trig = "v",
      name = "variable",
      dscr = "create local variable",
    },
    fmt("local {name} = {value}", {
      name = i(1, "name"),
      value = i(2, "value"),
    })
  ),

  s(
    {
      trig = "a",
      name = "assign",
      dscr = "make an assignment",
    },
    fmt("{name} = {value}", {
      name = i(1, "name"),
      value = i(2, "value"),
    })
  ),

  s({
    trig = "r",
    name = "return",
    dscr = "return",
  }, { t("return") }),

  s(
    {
      trig = "lreq",
      name = "local require",
      dscr = "local require module",
    },
    fmt('local {variable} = require("{module}")', {
      variable = d(2, function(module)
        local lastPart = module[1][1]:match("[^.]*$")
        return sn(nil, i(1, lastPart))
      end, 1),
      module = i(1, "module"),
    })
  ),

  s({
    trig = "req",
    name = "require",
    dscr = "require module",
  }, fmt('require("{}")', { i(1, "module") })),

  s(
    {
      trig = "lamb",
      name = "lambda",
      dscr = "create lambda function",
    },
    fmt(
      [[
        function()
          {1}
        end
      ]],
      { i(1) }
    )
  ),

  s(
    {
      trig = "f",
      name = "function",
      dscr = "create local function",
    },
    fmt(
      [[
        local function {name}({args})
          {body}
        end
      ]],
      {
        name = i(1, "name"),
        args = i(2, "args"),
        body = i(3, "body"),
      }
    )
  ),

  s(
    {
      trig = "fi",
      name = "for ipairs",
      dscr = "create for each element of list",
    },
    fmt(
      [[
        for {index}, {value} in ipairs({list}) do
          {body}
        end
      ]],
      {
        list = i(1, "list"),
        index = i(2, "_"),
        value = i(3, "v"),
        body = i(1),
      }
    )
  ),

  s(
    {
      trig = "fe",
      name = "for pairs",
      dscr = "create for each element of map",
    },
    fmt(
      [[
        for {key}, {value} in pairs({table}) do
          {body}
        end
      ]],
      {
        table = i(1, "table"),
        key = i(2, "k"),
        value = i(3, "v"),
        body = i(1),
      }
    )
  ),

  s(
    {
      trig = "if",
      name = "if statement",
      dscr = "create if statement",
    },
    fmt(
      [[
        if {condition} then
          {body}
        end
      ]],
      {
        condition = i(1),
        body = i(1),
      }
    )
  ),

  s(
    {
      trig = "ei",
      name = "elseif statement",
      dscr = "create elseif statement",
    },
    fmt(
      [[
        elseif {condition} then
          {body}
      ]],
      {
        condition = i(1),
        body = i(1),
      }
    )
  ),
}

return concatenateLists(vim, general)
