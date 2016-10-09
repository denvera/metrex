defmodule Metrex.MeterTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog
  alias Metrex.Meter

  @metric "test"
  @test_hooks Metrex.TestHooks
  @hooks Metrex.Hook.Default
  @ttl Application.get_env(:metrex, :ttl)

  setup do
    Application.put_env(:metrex, :hooks, @hooks)
    Meter.start_link(@metric)

    on_exit fn ->
      Metrex.Scheduler.Cleaner.unregister(Metrex.Meter, @metric, @ttl)
    end

    :ok
  end

  test "init" do
    assert Meter.dump(@metric) == []
  end

  test "init with test hook" do
    Application.put_env(:metrex, :hooks, @test_hooks)
    Meter.start_link("some_other")
    assert Meter.dump("some_other") == [{"0", 9}, {"1", 28}]
  end

  test "new metric is member of Cleaner schedulers" do
    assert Enum.member?(Metrex.Scheduler.Cleaner.dump, {Metrex.Meter, @metric, @ttl}) == true
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
    assert Meter.dump(@metric) == []
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    assert Meter.dump(@metric) |> Enum.count == 3
  end

  test "remove metric keys" do
    assert Meter.dump(@metric) == []
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    Enum.each(Meter.dump(@metric), fn({key, _val}) -> Meter.remove(@metric, key) end)
    assert Meter.dump(@metric) == []
  end

  test "reset metric data" do
    assert Meter.dump(@metric) == []
    Enum.each(0..2, fn(_x) -> :timer.sleep(1000); Meter.increment(@metric) end)
    Meter.reset(@metric)
    assert Meter.dump(@metric) == []
  end

  @tag :exit
  test "exit" do
    Application.put_env(:metrex, :hooks, @test_hooks)
    {:ok, pid} = Meter.start_link("some_new")
    assert capture_log(fn() -> GenServer.stop(pid, :normal) end) |> String.contains?("{\"0\", 9}, {\"1\", 28}")
  end
end
