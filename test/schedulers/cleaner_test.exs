defmodule CleanerTest do
  use ExUnit.Case
  alias Metrex.Meter
  alias Metrex.Scheduler.Cleaner

  @metric "cleaner"
  @ttl Application.get_env(:metrex, :ttl)

  setup do
    Meter.start_link(@metric)

    on_exit fn ->
      Cleaner.unregister(Meter, @metric, @ttl)
    end

    :ok
  end

  test "clean data in @ttl" do
    Enum.each(0..12, fn(_x) -> :timer.sleep(300); Meter.increment(@metric) end)
    assert Meter.dump(@metric) |> Enum.count > 0
    :timer.sleep((@ttl+1) * 1000)
    assert Meter.dump(@metric) |> Enum.count == 0
  end

  test "uniqueness of registered processes" do
    count = Cleaner.dump |> Enum.count
    Cleaner.register(Meter, @metric, @ttl)

    assert (Cleaner.dump |> Enum.count) == count
  end

  test "unregister" do
    Cleaner.unregister(Meter, @metric, @ttl)
    assert Enum.member?(Cleaner.dump, {Meter, @metric, @ttl}) == false
  end

  test "register" do
    Meter.start_link("some")
    Cleaner.unregister(Meter, "some", @ttl)
    Cleaner.register(Meter, "some", @ttl)
    assert Enum.member?(Cleaner.dump, {Meter, "some", @ttl}) == true
  end
end
