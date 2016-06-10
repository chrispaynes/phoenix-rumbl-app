defmodule InfoSys do
  # a listing of supported backends
  @backends [InfoSys.Wolfram]

  # defines the struct to hold search results
  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  # the proxy function
  # calls start_link() on the specified backend
  def start_link(backend, query, query_ref, owner, limit) do
    backend.start_link(query, query_ref, owner, limit)
  end

  # maps over all backends
  # calls depf spawn_query() on each
  # waits for results
  # sorts the results based on score reports top results
  def compute(query, opts \\ []) do
    limit = opts[:limit] || 10
    backends = opts[:backends] || @backends

    backends
    |> Enum.map(&spawn_query(&1, query, limit))
    |> await_results(opts)
    |> Enum.sort(&(&1.score >= &2.score))
    |> Enum.take(limit)
  end

  # monitors the child process
  # returns a tuple with the child PID, monitor reference and query reference
  defp spawn_query(backend, query, limit) do
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    {:ok, pid} = Supervisor.start_child(InfoSys.Supervisor, opts)
    monitor_ref = Process.monitor(pid)
    {pid, monitor_ref, query_ref}
  end

  # uses recursive accumulation
  # accepts a list of results to processe
  # reduces the children one by one  
  # retrieves the timeout option
  # sends itself a message after the timeout value
  # on each timeout, it kills the timed-out backend and moves to the next backend
  defp await_results(children, opts) do
    timeout = opts[:timeout] || 5000
    timer = Process.send_after(self(), :timedout, timeout)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  # recurses over all spawned backends
  # processes the results and returns a message
  # adds to the accumulate (acc) value
  defp await_result([head|tail], acc, timeout) do
    {pid, monitor_ref, query_ref} = head

    # attempts to receive next valid result and process it
    # drops the monitor and removes :DOWN from the mailbox
    # recurses with remaining children without adding to acc
    receive do
      {:results, ^query_ref, results} ->
        Process.demonitor(monitor_ref, [:flush])
        await_result(tail, results ++ acc, timeout)
        {:DOWN, ^monitor_ref, :process, ^pid, _reason} ->
          await_result(tail, acc, timeout)
        :timedout ->
          kill(pid, monitor_ref)
          await_result(tail, acc, 0)
    after 
      timeout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    end
  end

  defp await_result([], acc, _) do
    acc
  end

  # kills the backend process and removes the monitor
  defp kill(pid, ref) do
    Process.demonitor(ref, [:flush])
    Process.exit(pid, :kill)
  end

  # uses erlang to cancel the timer if it was already triggered
  # removes :timeout message from inbox if it was sent
  defp cleanup(timer) do
    :erlang.cancel_timer(timer)
    receive do
      :timedout -> :ok
    after
      0 -> :ok
    end
  end

end