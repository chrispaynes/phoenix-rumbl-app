defmodule Rumbl.Counter do
  
  # asynchronously sends :inc messages to server process
  def inc(pid), do: send(pid, :inc)

  # asynchronously sends :dec messages to server process
  def dec(pid), do: send(pid, :dec)

  # sends request for the counter value and waits for a response
  # if there's is no response, the current process is exited
  def val(pid, timeout \\ 5000) do
    ref = make_ref()
    send(pid, {:val, self(), ref})
    receive do
      {^ref, val} -> val
    after timeout -> exit(:timeout)
    end
  end

  # accepts initial counter state
  # spawns a process and returns {:ok, pid}
  # the spawned process calls defp listen()
  def start_link(initial_val) do
    {:ok, spawn_link(fn -> listen(initial_val) end)}
  end

  # uses tail recursion to manage state
  # processes messages
  # calls listen() when complete
  defp listen(val) do
    receive do
      :inc -> listen(val + 1)
      :dec -> listen(val - 1)
      {:val, sender, ref} ->
        send sender, {ref, val}
        listen(val)
    end
  end
end