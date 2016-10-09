defmodule Metrex.Hooks.DefaultTest do
  use ExUnit.Case

  @hooks Metrex.Hook.Default

  @metric "sample"

  test "counter init with 0" do
    assert @hooks.counter_init(@metric) == 0
  end

  test "counter exit with :ok" do
    assert @hooks.counter_exit(:kill, @metric, 9) == :ok
  end

  test "meter init with []" do
    assert @hooks.meter_init(@metric) == []
  end

  test "meter exit with :ok" do
    assert @hooks.meter_exit(:kill, @metric, [{"0", 999}]) == :ok
  end
end
