# Metrex

Simple metrics for elixir apps

## Installation

The package can be installed as:

  1. Add `metrex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:metrex, "~> 0.2.0"}]
    end
    ```

  2. Ensure `metrex` is started before your application:

    ```elixir
    def application do
      [applications: [:metrex]]
    end
    ```

## Usage

### Counters

#### Static counters

Add list of counters into config.exs or your env file to autostart counters:

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

To initialize counter with x(number), you need to define your hook. See hooks section for details.

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
```

### Meters

Timeseries counter approach to increment, decrement using unixtime stamp.

#### Static meters

Add list of counters into config.exs or your env file to autostart counters:

```elixir
config :metrex,
  meters: ["pageviews"],
  ttl: 900
```

#### On-demand meters

To create on-demand meters, you need to call `start_link` function:

```elixir
# Initialize meter with []
Metrex.start_meter("special_clicks")
```

To initialize meter with list of atoms, you need to define your hook. See hooks section for details.

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

## Hooks and Configurations

By default metrex does not have capability for initializing mertics with certain data or saving on exit situations. Because backend for saving and reloading may vary on applications. To overcome this situations, `metrex` comes with a simple hook module that you can hack. All you need to do create a hook module and add it config.exs or to your env `dev.exs`, `test.exs` and `prod.exs`.

File: `config.exs` or '`dev.exs`, `test.exs`, `prod.exs`':

```
config :metrex,
  ttl: 900,
  counters: ["sample_counter", "page_views"],
  meters: ["sample_meter", "page_views", "some_other"],
  hooks: SampleMetricsHook
```

File: `sample_metrics_hook.ex` (Sample hook function implementation)

```elixir
defmodule SampleMetricsHook do
  use Metrex.Hook

  @doc """
  Hook on `Metrex.Counter` init
  """
  def counter_init(metric) do
    0 # put some integer or load from source like redis, cachex, db, file, etc.
  end

  @doc """
  Default hook on `Metrex.Counter` exit
  """
  def counter_exit(reason, metric, val) do
    # save val on exit to destinations like redis, cachex, db, file, etc.
    :ok
  end

  @doc """
  Default hook on `Metrex.Meter` exit
  """
  def meter_init(metric) do
    [] # put some list of atoms or load from source like redis, cachex, db, file, etc.
  end

  @doc """
  Default hook on `Metrex.Meter` exit
  """
  def meter_exit(reason, metric, val) do
     # save val on exit to destinations like redis, cachex, db, file, etc.
    :ok
  end
end

```

## Contribution

### Issues, Bugs, Documentation, Enhancements

1) Fork the project

2) Make your improvements and write your tests.

3) Make a pull request.

## Todo

  - [x] Implement meters

  - [ ] Implement histograms

  - [ ] Implement timers

  - [ ] Implement gauges

  - [ ] Implement reporting service behaviour

  - [ ] Implement reporting services

## License

MIT
