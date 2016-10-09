defmodule Metrex.TestHooks do
  use Metrex.Hook
  require Logger

  def counter_init(metric),
    do: 5

  @doc """
  Default hook on `Metrex.Counter` exit
  """
  def counter_exit(reason, metric, val) do
    Logger.info("#{reason} #{metric} #{val}")
    :ok
  end

  @doc """
  Default hook on `Metrex.Meter` exit
  """
  def meter_init(metric),
    do: [{"0", 9}, {"1", 28}]

  @doc """
  Default hook on `Metrex.Meter` exit
  """
  def meter_exit(reason, metric, val) do
    Logger.info("#{reason} #{metric} #{inspect(val)}")
    :ok
  end
end
