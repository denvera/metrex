defmodule Metrex do
  @moduledoc """
  Metrex application
  """

  use Application

  @counters Application.get_env(:metrex, :counters) || []
  @meters Application.get_env(:metrex, :meters) || []

  @doc """
  Starts Metrex.Counter, Metrex.Meter agents when app starts
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    counters = Enum.map(@counters, fn(counter) ->
      worker(Metrex.Counter, [counter]) end
    )

    meters = Enum.map(@meters, fn(meter) ->
      worker(Metrex.Meter, [meter]) end
    )

    children = [
      worker(Metrex.Scheduler.Cleaner, [])
    ]

    opts = [strategy: :one_for_one, name: Metrex.Supervisor]
    Supervisor.start_link(children ++ counters ++ meters, opts)
  end
end
