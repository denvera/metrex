defmodule Metrex.MeterTest do
  use ExUnit.Case, async: true
  alias Metrex.Meter

  @metric "test"
  @ttl Application.get_env(:metrex, :ttl)

  setup do
    Meter.start_link(@metric)

    on_exit fn ->
      Metrex.Scheduler.Cleaner.unregister(Metrex.Meter, @metric, @ttl)
    end

    :ok
  end

  test "init" do
    assert Meter.dump(@metric) == %{}
  end

  test "new metric is member of " do
    assert Enum.member?(Metrex.Scheduler.Cleaner.dump, {Metrex.Meter, @metric, @ttl}) == true
  end

  test "init with val" do
    name = "test_with_start"
    Meter.start_link(name, %{0 => 9, 1 => 1})
    assert Meter.count(name, 0) == 9
    assert Meter.count(name, 1) == 1
  end

  test "increment by 1 if no val specified" do
    Meter.increment(@metric)
    assert Meter.count(@metric, :erlang.system_time(:seconds)) == 1
  end

  test "increment by val if val specified" do
    Meter.increment(@metric, 9)
    assert Meter.count(@metric, :erlang.system_time(:seconds)) == 9
  end

  test "decrement by 1 if no val specified" do
    Meter.decrement(@metric)
    assert Meter.count(@metric, :erlang.system_time(:seconds)) == -1
  end

  test "decrement by val if val specified" do
    Meter.decrement(@metric, 3)
    assert Meter.count(@metric, :erlang.system_time(:seconds)) == -3
  end

  test "dump all metric map" do
    assert Meter.dump(@metric) == %{}
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    assert Meter.dump(@metric) |> Enum.count == 3
  end

  test "remove metric keys" do
    assert Meter.dump(@metric) == %{}
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    Enum.each(Meter.dump(@metric), fn({key, _val}) -> Meter.remove(@metric, key) end)
    assert Meter.dump(@metric) == %{}
  end

  test "reset metric data" do
    assert Meter.dump(@metric) == %{}
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    Meter.reset(@metric)
    assert Meter.dump(@metric) == %{}
  end
end
