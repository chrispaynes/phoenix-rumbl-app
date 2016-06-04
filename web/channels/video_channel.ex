# Channel Module to process incoming events
defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel 

  # callback function authorizing or denying user channel access
  # assigns user to the socket matching the video ID
  # socket.assigns holds the state for the socket
  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end

end