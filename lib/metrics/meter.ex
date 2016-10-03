defmodule Metrex.Meter do
  @moduledoc """
  Meter metrics implementation. Timeseries counter approach to increment,
  decrement using unixtime stamp.

  ## Examples

  #### Static meters

  Add list of counters into config.exs file to autostart counters:

  ```elixir
  config :metrex,
    meters: ["pageviews"]
  ```

  #### On-demand meters

  To create on-demand meters, you need to call `start_link` function:

  ```elixir
  # Initialize counter with 0
  Metrex.Meter.start_link("special_clicks")

  # Initialize counter with x(number)
  Metrex.Meter.start_link("special_clicks", %{1475452816 => 35, 1475452816 => 28})
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

  # Get latest meter count
  Metrex.Meter.count("pageviews")

  # Get meter for unixtime
  Metrex.Meter.count("pageviews", 1475452816)

  # Dump meter map related to a metric
  Metrex.Meter.dump("pageviews")
  ```
  """

  alias Metrex.Counter

  @doc """
  Start a new meter metric
  """
  def start_link(metric) do
    metric_name = name(metric)
    Counter.start_link(metric_name)
    Agent.start_link(fn -> %{} end, name: String.to_atom(metric_name))
  end
  def start_link(metric, val = %{}) when val != %{} do
    metric_name = name(metric)
    {_, counter_val} = val |> Enum.to_list |> List.last
    Counter.start_link(metric_name, counter_val)
    Agent.start_link(fn -> val end, name: String.to_atom(metric_name))
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
  Display current counter
  """
  def count(metric),
    do: metric |> name |> Counter.count
  def count(metric, time),
    do: metric |> name |> String.to_atom |> Agent.get(&(&1)) |> Map.get(time, 0)

  @doc """
  Return all metric data
  """
  def dump(metric),
    do: metric |> name |> String.to_atom |> Agent.get(&(&1))

  defp name(metric),
    do: "meter." <> metric

  defp update(metric, val) do
    metric_name = name(metric)
    time = :erlang.system_time(:seconds)
    count = count(metric, time) + 1
    metric_name
    |> String.to_atom
    |> Agent.update(&(Map.put(&1, time, count)))
    Counter.increment(metric_name, val)
  end
end
