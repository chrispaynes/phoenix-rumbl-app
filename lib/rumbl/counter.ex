defmodule Rumbl.Counter do
  use GenServer
  
  # asynchronously sends :inc messages to server process
  def inc(pid), do: GenServer.cast(pid, :inc)

  # asynchronously sends :dec messages to server process
  def dec(pid), do: GenServer.cast(pid, :dec)

  # sends request for the counter value and pid, then waits for a response
  def val(pid) do
    GenServer.call(pid, :val)
  end

  # accepts initial counter state
  # spawns a process 
  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val)
  end

  # sends a "tick" message every 1000ms
  def init(initial_val) do
    Process.send_after(self, :tick, 1000)
    {:ok, initial_val}
  end

  # raises an error if counter val is less than 0
  # server is restarted to its initial state after the crash
  def handle_info(:tick, val) when val <= 0, do: raise "boom"

  # processes def init()'s' ticks
  # simulates a countdown
  def handle_info(:tick, val) do
    IO.puts "tick #{val}"
    Process.send_after(self, :tick, 1000)
    {:noreply, val - 1}
  end

  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end

end