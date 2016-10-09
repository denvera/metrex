defmodule Metrex.CounterSupervisor do
  @moduledoc """
  A supervisor for Metrex.Counter
  """

  use Supervisor
  alias Metrex.Counter

  @counters Application.get_env(:metrex, :counters) || []

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = Enum.map(@counters, fn(counter) ->
      worker(Counter, [counter], id: make_ref) end
    )

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end

  @doc false
  def start_child(metric) do
    import Supervisor.Spec, warn: false
    Supervisor.start_child(
      __MODULE__, worker(Counter, [metric], id: make_ref))
  end
end
