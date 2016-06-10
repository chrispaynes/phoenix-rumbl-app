defmodule InfoSys.Wolfram do
  # parses XML
  import SweetXml
  # Result holds the struct for incoming data
  alias InfoSys.Result

  # specifies the module to invoke and arguments to pass
  # designates ":fetch" as the task
  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end

  # uses the query to fetch the XML
  # extracts the results using sweet_xml's xpath()
  # sends the query results
  def fetch(query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_xml()
    |> xpath(~x"/queryresult/pod[contains(@title, 'Result') or
                                contains(@title, 'Definitions')]
                                /subpod/plaintext/text()")
    |> send_results(query_ref, owner)
  end

  # when no query results, sends an empty list
  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end

  # when query results are present, builds a results struct
  # users the owner's PID to send results to the client
  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: "wolfram", score: 95, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end

  # contacts Wolfram Alpha with the query string
  # uses :httpc (from Erlang) to perform http request
  # uses private function to extract App ID
  defp fetch_xml(query_str) do
    {:ok, {_, _, body}} = :httpc.request(
      String.to_char_list("http://api.wolframalpha.com/v2/query" <>
        "?appid=#{app_id()}" <>
        "&input=#{URI.encode(query_str)}&format=plaintext"))
    body
  end

  defp app_id, do: Application.get_env(:rumbl, :wolfram)[:app_id]
end