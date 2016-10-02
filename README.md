# Metrex

Simple metrics for elixir apps

## Installation

The package can be installed as:

  1. Add `metrex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:metrex, "~> 0.0.1"}]
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

## Contribution

### Issues, Bugs, Documentation, Enhancements

1) Fork the project

2) Make your improvements and write your tests.

3) Make a pull request.

## Todo

[ ] Implement meters
[ ] Implement histograms
[ ] Implement timers
[ ] Implement gauges
[ ] Implement reporting service behaviour
[ ] Implement reporting services

## License

MIT
