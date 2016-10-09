defmodule Metrex do
  @moduledoc """
  Metrex application
  """

  use Application

  @doc """
  Starts `Metrex.Counter, Metrex.Meter` and Cleaner when app starts
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Metrex.CounterSupervisor, []),
      supervisor(Metrex.MeterSupervisor, []),
      worker(Metrex.Scheduler.Cleaner, [])
    ]

    opts = [strategy: :one_for_one, name: Metrex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Starts `Metrex.Counter` child
  """
  def start_counter(metric),
    do: Metrex.CounterSupervisor.start_child(metric)

  @doc """
  Starts `Metrex.Meter` child
  """
  def start_meter(metric),
    do: Metrex.MeterSupervisor.start_child(metric)
end
