require Logger
defmodule Notacpu.Cpu do
  ## 64bits, because we're wasteful
  @instrsize 8
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{pc: 0, status: 0}, name: __MODULE__)
  end

  def init(initstate) do
    Logger.debug("CPU Initialized")
    {:ok, initstate}
  end



  def handle_call(:tick, _from, state = %{pc: pc}) do
    instrword = GenServer.call(Notacpu.Memory, {:read, pc, @instrsize})
#    Logger.debug("CPU: Instruction read from memory #{pc}: #{inspect(instrword)}")

    newpc = 
    case pc+@instrsize >= 65535 do
      true -> pc+@instrsize - 65536
      false -> pc+@instrsize
    end

    newstate =  Map.put(state, :pc, newpc)
    {:reply, %{state: newstate, lastinstr: instrword}, newstate}
  end



end
