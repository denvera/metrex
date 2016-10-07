defmodule MetrexTest do
  use ExUnit.Case
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

  test "sample meter child metric is alive?" do
    Metrex.start_meter("meter_child")
    refute is_nil(GenServer.whereis(:"meter.meter_child"))
  end
end
