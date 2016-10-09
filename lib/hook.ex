defmodule Metrex.Hook do
  @moduledoc """
  This module helps to sync and async hooks into the lifecycle of
  init and exit signals for metrics.

  Please refer to `README.md` file for more information.
  """

  use Behaviour

  defmacro __using__(_) do
    quote do
      @behaviour Metrex.Hook

      @doc """
      Default hook on `Metrex.Counter` init
      """
      def counter_init(metric),
        do: 0

      @doc """
      Default hook on `Metrex.Counter` exit
      """
      def counter_exit(reason, metric, val),
        do: :ok

      @doc """
      Default hook on `Metrex.Meter` init
      """
      def meter_init(metric),
        do: []

      @doc """
      Default hook on `Metrex.Meter` exit
      """
      def meter_exit(reason, metric, val),
        do: :ok

      defoverridable [
        {:counter_init, 1},
        {:counter_exit, 3},
        {:meter_init, 1},
        {:meter_exit, 3}
      ]
    end
  end

  @callback counter_init(metric :: String.t) :: integer

  @callback counter_exit(reason :: atom, metric :: String.t, val :: integer) :: :ok

  @callback meter_init(metric :: String.t) :: list(atom)

  @callback meter_exit(reason :: atom, metric :: String.t, val :: list(atom)) :: :ok
end