defmodule Metrex.CounterTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog
  alias Metrex.Counter

  @metric "test"
  @test_hooks Metrex.TestHooks
  @hooks Metrex.Hook.Default

  setup do
    Application.put_env(:metrex, :hooks, @hooks)
    Counter.start_link(@metric)
    :ok
  end

  test "init with 0" do
    assert Counter.count(@metric) == 0
  end

  test "init with 5" do
    Application.put_env(:metrex, :hooks, @test_hooks)
    Counter.start_link("some_other")
    assert Counter.count("some_other") == 5
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

  @tag :exit
  test "exit" do
    Application.put_env(:metrex, :hooks, @test_hooks)
    {:ok, pid} = Counter.start_link("some_new")
    Counter.increment("some_new")
    assert capture_log(fn() -> GenServer.stop(pid, :normal) end) |> String.contains?("normal some_new 6")
  end
end
