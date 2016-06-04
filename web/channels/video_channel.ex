# Channel Module to process incoming events
defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel 

  # callback function authorizing or denying user channel access
  # assigns user to the socket matching the video ID
  # socket.assigns holds the state for the socket
  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
  end

  # called when an elixir message reaches the channel
  # callback to handle annotation events pushed from the client
  # broadcasts new annotations to all clients on the current topic
  # sends status reply upon completion
  def handle_in("new_annotation", params, socket) do
    broadcast! socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    }

    {:reply, :ok, socket}
  end


  # PING TEST IMPLEMENTATION
  # # called when an elixir message reaches the channel
  # # match on the :ping message
  # # receives current socket and increments counter by one
  # # when there is not a reply, assign an incremented count value
  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push socket, "ping", %{count: count}

  #   {:noreply, assign(socket, :count, count + 1)}
  # end  

end