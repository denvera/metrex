defmodule MetrexTest do
  use ExUnit.Case
  doctest Metrex

  test "sample counter metric is alive?" do
    refute is_nil(GenServer.whereis(:"counter.sample"))
  end
end
