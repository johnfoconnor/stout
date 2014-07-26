defmodule Stout do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Stout.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stout.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defdelegate [
    trace_console(filter),
    trace_file(file, filter, level),
    stop_trace(trace),
    clear_all_traces(),
    status(),
    set_loglevel(handler, level),
    set_loglevel(handler, indent, level),
    get_loglevel(handler),
    posix_error(error)
  ], to: :lager

  levels =
    [debug:      7,
     info:       6,
     notice:     5,
     warning:    4,
     error:      3,
     critical:   2,
     alert:      1,
     emergency:  0,
     none:      -1
    ]

  for {level, _num} <- levels do
    defmacro unquote(level)(message) do
      log(unquote(level), '~s', [message], __CALLER__)
    end

    defmacro unquote(level)(format, message) do
      log(unquote(level), format, message, __CALLER__)
    end
  end

  for {level, num} <- levels do
    defp level_to_num(unquote(level)), do: unquote(num)
  end

  defp level_to_num(_), do: nil

  defp log(level, format, args, caller) do
    {name, __arity} = caller.function || {:unknown, 0}
    module = caller.module || :unknown
    if is_binary(format), do: format = String.to_char_list(format)
    if should_log(level) do
       dispatch(level, module, name, caller.line, format, args)
    end
  end

  defp dispatch(level, module, name, line, format, args) do
    quote do
      :lager.dispatch_log(unquote(level),
         [module: unquote(module),
          function: unquote(name),
          line: unquote(line),
          pid: self],
         unquote(format), unquote(args), unquote(compile_truncation_size))
    end
  end

  defp should_log(level), do: level_to_num(level) <= level_to_num(compile_log_level)

  defp compile_log_level() do
    Application.get_env(:stout, :level, :debug)
  end

  defp compile_truncation_size() do
    Application.get_env(:stout, :truncation_size, 4096)
  end
end