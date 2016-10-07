defmodule Metrex.Meter do
  @moduledoc """
  Meter metrics implementation. Timeseries counter approach to increment,
  decrement using unixtime stamp.

  ## Examples

  #### Static meters

  Add list of counters into config.exs file to autostart counters:

  ```elixir
  config :metrex,
    meters: ["pageviews"],
    ttl: 900
  ```

  #### On-demand meters

  To create on-demand meters, you need to call `start_link` function:

  ```elixir
  # Initialize counter with 0
  Metrex.start_meter("special_clicks")

  # Initialize counter with x(number)
  Metrex.start_meter("special_clicks", [{"1475452816", 5}, {"1475452816", 28}])
  ```

  #### Meter operations

  Meter operations are increment, decrement, count and dump:

  ```elixir
  # Increment a meter by 1
  Metrex.Meter.increment("pageviews")

  # Increment a meter by x(number)
  Metrex.Meter.increment("pageviews", 5)

  # Decrement a meter by 1
  Metrex.Meter.decrement("pageviews")

  # Decrement a meter by x(number)
  Metrex.Meter.decrement("pageviews", 3)

  # Get meter for unixtime
  Metrex.Meter.count("pageviews", 1475452816)

  # Dump meter map related to a metric
  Metrex.Meter.dump("pageviews")
  ```
  """

  use GenServer
  alias Metrex.Scheduler.Cleaner

  @ttl Application.get_env(:metrex, :ttl)

  @doc """
  Start a new meter metric
  """
  def start_link(metric),
    do: start_link(metric, [])
  def start_link(metric, val) when is_list(val) do
    Cleaner.register(__MODULE__, metric, @ttl)
    GenServer.start_link(__MODULE__, val, name: process_name(metric))
  end

  @doc """
  Increment metric by given val
  """
  def increment(metric, val \\ 1),
    do: update(metric, val)

  @doc """
  Decrement metric by given val
  """
  def decrement(metric, val \\ 1),
    do: update(metric, -val)

  @doc """
  Remove metric at the time
  """
  def remove(metric, time),
    do: metric |> process_name |> GenServer.cast({:remove, time})

  @doc """
  Reset all the metric data
  """
  def reset(metric),
    do: metric |> process_name |> GenServer.cast({:reset})

  @doc """
  Display current counter at given time
  """
  def count(metric, time),
    do: metric |> process_name |> GenServer.call({:count, time})

  @doc """
  Return all metric data
  """
  def dump(metric),
    do: metric |> process_name |> GenServer.call({:dump})

  defp update(metric, val),
    do: metric |> process_name |> GenServer.cast({:update, val})

  defp process_name(metric),
    do: String.to_atom("meter." <> metric)

  ## Private API

  @doc false
  def handle_call({:dump}, _from, state),
    do: {:reply, state, state}

  @doc false
  def handle_call({:count, time}, _from, state) do
    time = "#{time}"
    {_, count_val} = List.keyfind(state, time, 0) || {time, 0}
    {:reply, count_val, state}
  end

  @doc false
  def handle_cast({:update, val}, state) do
    time = "#{:erlang.system_time(:seconds)}"
    state =
      case List.keyfind(state, time, 0) do
        nil ->
          List.insert_at(state, 0, {time, val})
        {time, count_val} ->
          List.keyreplace(state, time, 0, {time, count_val + val})
      end
    {:noreply, state}
  end

  @doc false
  def handle_cast({:reset}, _state),
    do: {:noreply, []}

  @doc false
  def handle_cast({:remove, time}, state),
    do: {:noreply, List.keydelete(state, "#{time}", 0)}
end
