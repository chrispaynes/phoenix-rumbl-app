defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  # regex to extract youtube video's "id"
  # names "id" pattern
  # pipes to named_captures which extracts url
  # builds map that returns id key with its value pair
  def player_id(video) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end

end