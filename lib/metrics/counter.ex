defmodule Metrex.Counter do
  @moduledoc """
  Counter metrics implementation

  ## Examples

  #### Static counters

  Add list of counters into config.exs file to autostart counters:

  ```elixir
  config :metrex,
    counters: ["pageviews"]
  ```

  #### On-demand counters

  To create on-demand counters, you need to call `start_link` function:

  ```elixir
  # Initialize counter with 0
  Metrex.start_counter("special_clicks")

  # Initialize counter with x(number)
  Metrex.start_counter("special_clicks", 28)
  ```

  #### Counter operations

  Counter operations are increment, decrement and count:

  ```elixir
  # Increment a counter by 1
  Metrex.Counter.increment("pageviews")

  # Increment a counter by x(number)
  Metrex.Counter.increment("pageviews", 5)

  # Decrement a counter by 1
  Metrex.Counter.decrement("pageviews")

  # Decrement a counter by x(number)
  Metrex.Counter.decrement("pageviews", 3)

  # Get current counter
  Metrex.Counter.count("pageviews")
  """

  @doc """
  Start a new counter metric
  """
  def start_link(metric, val \\ 0),
    do: Agent.start_link(fn -> val end, name: name(metric))

  @doc """
  Increment metric by given val
  """
  def increment(metric, val \\ 1),
    do: Agent.update(name(metric), &(&1 + val))

  @doc """
  Decrement metric by given val
  """
  def decrement(metric, val \\ 1),
    do: Agent.update(name(metric), &(&1 - val))

  @doc """
  Display current counter
  """
  def count(metric),
    do: Agent.get(name(metric), &(&1))

  defp name(metric),
    do: String.to_atom("counter." <> metric)
end
