defmodule Metrex.MeterTest do
  use ExUnit.Case, async: true
  alias Metrex.Meter

  @metric "test"

  setup do
    Meter.start_link(@metric)
    :ok
  end

  test "init with 0 if no counter specified" do
    assert Meter.count(@metric) == 0
  end

  test "init with val" do
    name = "test_with_start"
    Meter.start_link(name, %{0 => 9, 1 => 1})
    Meter.increment(name)
    assert Meter.count(name) == 2
    assert Meter.count(name, 1) == 1
  end

  test "increment by 1 if no val specified" do
    Meter.increment(@metric)
    assert Meter.count(@metric) == 1
  end

  test "increment by val if val specified" do
    Meter.increment(@metric, 9)
    assert Meter.count(@metric) == 9
  end

  test "decrement by 1 if no val specified" do
    Meter.decrement(@metric)
    assert Meter.count(@metric) == -1
  end

  test "decrement by val if val specified" do
    Meter.decrement(@metric, 3)
    assert Meter.count(@metric) == -3
  end

  test "return all metric map" do
    assert Meter.dump(@metric) == %{}
    Enum.each(0..2, fn(x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    assert Meter.count(@metric) == 3
    assert Meter.dump(@metric) |> Enum.count == 3
  end
end
