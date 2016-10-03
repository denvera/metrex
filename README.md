# Metrex

Simple metrics for elixir apps

## Installation

The package can be installed as:

  1. Add `metrex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:metrex, "~> 0.0.2"}]
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

Add list of counters into config.exs file to autostart counters:

```elixir
config :metrex,
  counters: ["pageviews"]
```

#### On-demand counters

To create on-demand counters, you need to call `start_link` function:

```elixir
# Initialize counter with 0
Metrex.Counter.start_link("special_clicks")

# Initialize counter with x(number)
Metrex.Counter.start_link("special_clicks", 28)
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
```

### Meters

Timeseries counter approach to increment, decrement using unixtime stamp.

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
