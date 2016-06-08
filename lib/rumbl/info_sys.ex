defmodule Rumbl.InfoSys do
  # a listing of supported backends
  @backends [Rumbl.InfoSys.Wolfram]

  # defines the struct to hold search results
  defmodule Result do
    defstruct score: 0 text: nil, url: nil, backend: nil
  end

  # the proxy function
  # calls start_link() on the specified backend
  def start_link(backend, query, query_ref, owner, limit) do
    backend.start_link(query, query_ref, owner, limit)
  end

  # maps over all backends
  # calls depf spawn_query() on each
  def compute(query, opts \\ []) do
    limit = opts[:limit] || 10
    backends = opts[:backends] || @backends

    backends
    |> Enum.map(&spawn_query(&1, query, limit))
  end

  # returns the PID and unique reference
  defp spawn_query(backend, query, limit) do
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    {:ok, pid} = Supervisor.start_child(Rumbl.InfoSys.Supervisor, opts)
    {pid, query_ref}
  end

end