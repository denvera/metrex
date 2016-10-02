defmodule Metrex.CounterTest do
  use ExUnit.Case, async: true
  alias Metrex.Counter

  @metric "test"

  setup do
    Counter.start_link(@metric)
    :ok
  end

  test "init with 0 if no counter specified" do
    assert Counter.count(@metric) == 0
  end

  test "init with 5 if counter specified 5" do
    metric_name = "another_metric"
    Counter.start_link(metric_name, 5)
    assert Counter.count(metric_name) == 5
  end

  test "increment by 1 if no val specified" do
    Counter.increment(@metric)
    assert Counter.count(@metric) == 1
  end

  test "increment by val if val specified" do
    Counter.increment(@metric, 9)
    assert Counter.count(@metric) == 9
  end

  test "decrement by 1 if no val specified" do
    Counter.decrement(@metric)
    assert Counter.count(@metric) == -1
  end

  test "decrement by val if val specified" do
    Counter.decrement(@metric, 3)
    assert Counter.count(@metric) == -3
  end
end
