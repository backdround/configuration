---@diagnostic disable: undefined-global
--# selene: allow(undefined_variable)

local get_variable_representation_nodes = function()
  return fmt([["{representation}: " .. {variable}]], {
    variable = c(1, {
      i(1, "name"),
      sn(2, fmt("tostring({})", i(1, "name"))),
      sn(3, fmt("vim.inspect({})", i(1, "name"))),
    }),
    representation = d(2, function(args)
      local variable_name = args[1][1]:match("%((.*)%)")
      if not variable_name then
        variable_name = args[1][1]
      end
      return sn(nil, i(1, variable_name))
    end, 1),
  })
end

local neovim = {
  s({
    trig = ",n",
    name = "vim notify",
    dscr = "print variable with desktop notification",
    snippetType = "autosnippet",
  }, fmt('require("utilities").notify({})', { i(1) })),
}

local variables = {
  s(
    {
      trig = ",lv",
      name = "variable",
      dscr = "define local variable",
      snippetType = "autosnippet",
    },
    fmt("local {name} = {value}", {
      name = i(1, "name"),
      value = i(2, "value"),
    })
  ),

  s(
    {
      trig = ",a",
      name = "assign",
      dscr = "assign",
      snippetType = "autosnippet",
    },
    fmt("{name} = {value}", {
      name = i(1, "name"),
      value = d(2, function(args)
        return sn(nil, i(1, args[1][1]))
      end, 1),
    })
  ),
}

local output = {
  s(
    {
      trig = ",out",
      name = "print",
      dscr = "print value",
      snippetType = "autosnippet",
    },
    fmt("print({value})", {
      value = i(1, "value"),
    })
  ),

  s({
    trig = ",vout",
    name = "vebose print",
    dscr = "print value with its name",
    snippetType = "autosnippet",
  }, fmt("print({})", sn(1, get_variable_representation_nodes()))),
}

local loops = {
  s(
    {
      trig = ",fi",
      name = "for ipairs",
      dscr = "create for each element of list",
      snippetType = "autosnippet",
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
        body = i(4),
      }
    )
  ),

  s(
    {
      trig = ",fe",
      name = "for pairs",
      dscr = "create for each element of map",
      snippetType = "autosnippet",
    },
    fmt(
      [[
        for {key}, {value} in pairs({table}) do
          {body}
        end
      ]],
      {
        table = i(1, "table"),
        key = i(2, "key"),
        value = i(3, "value"),
        body = i(4),
      }
    )
  ),

  s(
    {
      trig = ",for",
      name = "for",
      dscr = "create basic for",
      snippetType = "autosnippet",
    },
    fmt(
      [[
        for i = {from}, {to} do
          {body}
        end
      ]],
      {
        from = i(1, "1"),
        to = i(2, "n"),
        body = i(3),
      }
    )
  ),
}

local functions = {
  s(
    {
      trig = ",la",
      name = "lambda",
      dscr = "create lambda function",
      snippetType = "autosnippet",
    },
    fmt(
      [[
      function({1})
        {2}
      end
    ]],
      { i(1), i(2) }
    )
  ),

  s({
    trig = ",il",
    name = "inline lambda",
    dscr = "create inline lambda function",
    snippetType = "autosnippet",
  }, fmt("function() {1} end", { i(1) })),

  s(
    {
      trig = ",lf",
      name = "local function",
      dscr = "universal local function",
      snippetType = "autosnippet",
    },
    c(1, {
      sn(
        1,
        fmt(
          [[
            local {name} = function({args})
              {body}
            end
          ]],
          {
            name = i(1, "name"),
            args = i(2),
            body = i(3),
          }
        )
      ),
      sn(
        2,
        fmt(
          [[
            local function {name}({args})
              {body}
            end
          ]],
          {
            name = i(1, "name"),
            args = i(2),
            body = i(3),
          }
        )
      ),
    })
  ),
}

local statements = {
  s({
    trig = ",r",
    name = "return",
    dscr = "return",
    snippetType = "autosnippet",
  }, {
    t("return "),
  }),

  s(
    {
      trig = ",if",
      name = "if statement",
      dscr = "create if statement",
      snippetType = "autosnippet",
    },
    fmt(
      [[
        if {condition} then
          {body}
        end
      ]],
      {
        condition = i(1),
        body = i(2),
      }
    )
  ),

  s(
    {
      trig = ",lr",
      name = "local require",
      dscr = "local require",
      snippetType = "autosnippet",
    },
    fmt('local {variable} = require("{module}")', {
      variable = d(2, function(module)
        local last_part = module[1][1]:match("[^.]*$")
        local module_name = last_part:gsub("-", "_")
        return sn(nil, i(1, module_name))
      end, 1),
      module = i(1, "module"),
    })
  ),

  s({
    trig = ",gr",
    name = "require",
    dscr = "global require",
    snippetType = "autosnippet",
  }, fmt('require("{}")', { i(1, "module") })),
}

local misc = {
  s({
    trig = ",.",
    name = "concatenate",
    dscr = "concatenate strings",
    snippetType = "autosnippet",
  }, fmt([[.. "{}"]], i(1, "\\n"))),

  s({
    trig = ",vr",
    name = "verbose representation",
    dscr = "make a verbose representation name",
    snippetType = "autosnippet",
  }, get_variable_representation_nodes()),
}

local snippet_lists = {
  neovim,
  variables,
  output,
  loops,
  functions,
  statements,
  misc,
}

return array_extend(unpack(snippet_lists))
