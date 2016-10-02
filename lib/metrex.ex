defmodule Metrex do
  @moduledoc """
  Metrex application
  """

  use Application

  @counters Application.get_env(:metrex, :counters) || []

  @doc """
  Starts Metrex.Counter agents when app starts
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = Enum.map(@counters, fn(counter) ->
      worker(Metrex.Counter, [counter]) end
    )

    opts = [strategy: :one_for_one, name: Metrex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
