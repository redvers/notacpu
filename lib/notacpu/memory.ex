require Logger
defmodule Notacpu.Memory do
  @size 65535
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    mem = List.duplicate(0, @size)
    Logger.debug("Memory Initialized")
    {:ok, mem}
  end

  def handle_call({:read, from, length}, _from, mem) do
    res = Enum.slice(mem, from, length)
    |> :binary.list_to_bin
    {:reply, res, mem}
  end


end
