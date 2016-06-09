defmodule Rumbl.InfoSys do
  # a listing of supported backends
  @backends [Rumbl.InfoSys.Wolfram]

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
    {:ok, pid} = Supervisor.start_child(Rumbl.InfoSys.Supervisor, opts)
    monitor_ref = Process.monitor(pid)
    {pid, monitor_ref, query_ref}
  end

  # uses recursive accumulation
  # accepts a list of results to processe
  # reduces the children one by one  
  defp await_results(children, _opts) do
    await_result(children, [], :infinity)
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
    end
  end

  defp await_result([], acc, _) do
    acc
  end

end