defmodule MetrexTest do
  use ExUnit.Case
  alias Metrex.Counter
  alias Metrex.Meter
  doctest Metrex

  test "sample counter metric is alive?" do
    refute is_nil(GenServer.whereis(:"counter.c_sample"))
  end

  test "sample meter metric is alive?" do
    refute is_nil(GenServer.whereis(:"meter.m_sample"))
  end

  test "sample counter child metric is alive?" do
    Metrex.start_counter("counter_child")
    refute is_nil(GenServer.whereis(:"counter.counter_child"))
  end

  test "sample counter child metric with counter val" do
    Metrex.start_counter("counter_with_val", 9)
    assert Counter.count("counter_with_val") == 9
  end

  test "sample meter child metric is alive?" do
    Metrex.start_meter("meter_child")
    refute is_nil(GenServer.whereis(:"meter.meter_child"))
  end

  test "sample meter child metric with val" do
    time = :erlang.system_time(:seconds)
    Metrex.start_meter("meter_with_val", [{"#{time}", 9}, {"#{time+1}",1}])
    assert Meter.count("meter_with_val", time) == 9
    assert Meter.count("meter_with_val", time + 1) == 1
  end
end
