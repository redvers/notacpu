defmodule Notacpu.Clockpanel do
  @delay 1000
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{state: :wait, delay: @delay}, name: __MODULE__)
  end

  def run do
    GenServer.cast(__MODULE__, :start)
  end
  def wait do
    GenServer.cast(__MODULE__, :wait)
  end

  def handle_cast(:start, state) do
    send(self, :tick)
    {:noreply, Map.put(state, :state, :running)}
  end

  def handle_cast(:wait, state) do
    {:noreply, Map.put(state, :state, :wait)}
  end

  def handle_info(:tick, state = %{state: :wait}) do
    IO.puts("CLK: Single step")
    exec_cpu_tick(state)
    {:noreply, state}
  end

  def handle_info(:tick, state = %{state: :running, delay: delay}) do
    exec_cpu_tick(state)
    :erlang.send_after(delay, self, :tick)
    {:noreply, state}
  end

  def exec_cpu_tick(state) do
    result = GenServer.call(Notacpu.Cpu, :tick)
    IO.inspect(result)
  end



end
