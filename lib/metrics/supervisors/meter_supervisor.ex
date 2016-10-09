defmodule Metrex.MeterSupervisor do
  @moduledoc """
  A supervisor for Metrex.Meter
  """

  use Supervisor
  alias Metrex.Meter

  @meters Application.get_env(:metrex, :meters) || []

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = Enum.map(@meters, fn(meter) ->
      worker(Meter, [meter], id: make_ref) end
    )

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end

  @doc false
  def start_child(metric) do
    import Supervisor.Spec, warn: false
    Supervisor.start_child(
      __MODULE__, worker(Meter, [metric], id: make_ref))
  end
end
