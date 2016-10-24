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

  use GenServer

  @count "count"
  @name "name"

  def init(val) do
    Process.flag(:trap_exit, true)
    hooks = Application.get_env(:metrex, :hooks)
    {_, metric} = List.keyfind(val, @name, 0)
    {:ok, [{@count, hooks.counter_init(metric)}] ++ val}
  end

  @doc """
  Start a new `Counter` metric
  """
  def start_link(metric) do
    GenServer.start_link(__MODULE__, [{@name, metric}],
      name: process_name(metric))
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
  Reset counter
  """
  def remove(metric, _),
    do: reset(metric)

  @doc """
  Reset counter
  """
  def reset(metric),
    do: metric |> process_name |> GenServer.cast({:reset})

  @doc """
  Display current counter at given time
  """
  def count(metric),
    do: metric |> process_name |> GenServer.call({:count})

  ## Private

  defp update(metric, val),
    do: metric |> process_name |> GenServer.cast({:update, val})

  defp process_name(metric),
    do: String.to_atom("counter." <> metric)

  ## Private API

  @doc false
  def handle_call({:count}, _from, state) do
    {_, count_val} = List.keyfind(state, @count, 0) || {@count, 0}
    {:reply, count_val, state}
  end

  @doc false
  def handle_cast({:update, val}, state) do
    {_, count_val} = List.keyfind(state, @count, 0)
    {:noreply, List.keyreplace(state, @count, 0, {@count, count_val + val})}
  end

  @doc false
  def handle_cast({:reset}, state),
    do: {:noreply, [{@count, 0}, List.keyfind(state, @name, 0)]}

  @doc false
  def handle_info({:EXIT, _pid, reason}, state) do
    {:stop, reason, state}
  end

  @doc false
  def terminate(reason, state) do
    {_, metric} = List.keyfind(state, @name, 0)
    {_, val} = List.keyfind(state, @count, 0)
    hooks = Application.get_env(:metrex, :hooks)
    hooks.counter_exit(reason, metric, val)
    :ok
  end
end
