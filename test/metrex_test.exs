defmodule MetrexTest do
  use ExUnit.Case
  doctest Metrex

  test "sample counter metric is alive?" do
    refute is_nil(GenServer.whereis(:"counter.c_sample"))
  end

  test "sample meter metric is alive?" do
    refute is_nil(GenServer.whereis(:"meter.m_sample"))
  end
end
