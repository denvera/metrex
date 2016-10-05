defmodule Metrex.Scheduler.Cleaner do
  @moduledoc """
  Scheduled metrics cleaner
  """

  use GenServer
  require Logger

  @doc """
  Register a metric type.
  """
  def register(metric_type, metric_name, ttl),
    do: GenServer.cast(__MODULE__, {:register, metric_type, metric_name, ttl})

  @doc """
  Unregister a metric type.
  """
  def unregister(metric_type, metric_name, ttl),
    do: GenServer.cast(__MODULE__, {:unregister, metric_type, metric_name, ttl})

  @doc """
  List registered metrics
  """
  def dump,
    do: GenServer.call(__MODULE__, {:dump})

  ## Callbacks

  @doc false
  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init(_opts) do
    schedule_work()
    {:ok, []}
  end

  ## Private API

  @doc false
  def handle_cast({:register, metric_type, metric_name, ttl}, metrics) do
    metrics = metrics
              |> List.insert_at(0, {metric_type, metric_name, ttl})
              |> Enum.uniq
    {:noreply, metrics}
  end

  @doc false
  def handle_cast({:unregister, metric_type, metric_name, ttl}, metrics),
    do: {:noreply, List.delete(metrics, {metric_type, metric_name, ttl})}

  @doc false
  def handle_cast({:clean_metric, metric_type, metric_name, time}, metrics) do
    metric_type.remove(metric_name, time)
    {:noreply, metrics}
  end

  @doc false
  def handle_info(:clean, metrics) do
    schedule_work()
    Enum.each(metrics, fn({metric_type, metric_name, ttl}) ->
      time = :erlang.system_time(:seconds) - ttl
      GenServer.cast(__MODULE__,
        {:clean_metric, metric_type, metric_name, time}) end)
    {:noreply, metrics}
  end

  @doc false
  def handle_call({:dump}, _from, metrics),
    do: {:reply, metrics, metrics}

  defp schedule_work,
    do: Process.send_after(self(), :clean, 1_000)
end
