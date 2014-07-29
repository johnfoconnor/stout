[
  mappings: [
    "lager.handlers.console.level": [
      to: "lager.handlers",
      datatype: [enum: [:debug, :info, :error]],
      default: :info
    ],
    "lager.handlers.files.level": [
      to: "lager.handlers",
      datatype: [list: [enum: [:debug, :info, :error]]],
      default: [
                :error, :info, :debug
      ]
    ],
    "lager.handlers.files.dirname": [
      to: "lager.handlers",
      datatype: :charlist,
      default: 'log/'
    ],
    "lager.handlers.files.size": [
      to: "lager.handlers",
      datatype: :integer,
      default: 10485760
    ],
    "lager.handlers.files.date": [
      to: "lager.handlers",
      datatype: :charlist,
      default: '$D0'
    ],
    "lager.handlers.files.count": [
      to: "lager.handlers",
      datatype: :integer,
      default: 5
    ],
    "stout.level": [
      doc: "Provide documentation for stout.level here.",
      to: "stout.level",
      datatype: :atom,
      default: :info
    ],
    "stout.truncation_size": [
      doc: "Provide documentation for stout.truncation_size here.",
      to: "stout.truncation_size",
      datatype: :integer,
      default: 4096
    ]
  ],
  translations: [
    "lager.handlers.console.level": fn
      _, level ->
        [lager_console_backend: level]
      end,
    "lager.handlers.files.level": fn
       _, levels, conf_acc ->
         conf_acc ++ Enum.map(levels, &([lager_file_backend: [level: &1]]))
      end,
    "lager.handlers.files.dirname": fn
       _, dirname, conf_acc ->
         fun = fn (conf) ->
                    filename = conf[:level] |> Atom.to_char_list
                    [{:file, dirname ++ filename ++ '.log'}] ++ conf
               end
         Enum.map(conf_acc,
                  fn([{:lager_file_backend, conf}]) ->
                      [lager_file_backend: fun.(conf)]
                    (a) -> a
                  end)
      end,
    "lager.handlers.files.size": fn
       _, size, conf_acc ->
         fun = fn (conf) ->
                    [size: size] ++ conf
               end
         Enum.map(conf_acc,
                  fn([{:lager_file_backend, conf}]) ->
                      [lager_file_backend: fun.(conf)]
                    (a) -> a
                  end)
      end,
    "lager.handlers.files.date": fn
       _, date, conf_acc ->
         fun = fn (conf) ->
                    [date: date] ++ conf
               end
         Enum.map(conf_acc,
                  fn([{:lager_file_backend, conf}]) ->
                      [lager_file_backend: fun.(conf)]
                    (a) -> a
                  end)
      end,
    "lager.handlers.files.count": fn
       _, count, conf_acc ->
         fun = fn (conf) ->
                    [count: count] ++ conf
               end
         Enum.map(conf_acc,
                  fn([{:lager_file_backend, conf}]) ->
                      [lager_file_backend: fun.(conf)]
                    (a) -> a
                  end)
      end
  ]
]