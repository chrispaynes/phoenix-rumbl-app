# Channel Module to process incoming events
defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel 
  alias Rumbl.AnnotationView

  # callback function authorizing or denying user channel access
  # assigns user to the socket matching the video ID
  # socket.assigns holds the state for the socket
  def join("videos:" <> video_id, _params, socket) do
    video_id = String.to_integer(video_id)
    video = Repo.get!(Rumbl.Video, video_id)
    annotations = Repo.all(
      from a in assoc(video, :annotations),
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )

    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  # called when an elixir message reaches the channel
  # callback to handle annotation events pushed from the client
  # broadcasts new annotations to all clients on the current topic
  # sends status reply upon completion

  # handle_in/3
  # ensures all incoming events have current user
  # looks up user from socket assigns
  # calls handle_in/4
  def handle_in{event, params, socket} do
    user = Repo.get(Rumbl.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)  
  end

  # handle_in/4
  # builds annotation changeset
  # inserts changeset into Repo
  # if Repo insertion is successful, it broadcasts to all subscribers
  # acknowledges client messages pushed successfully
  # if unsuccessful, changeset errors are returned
  # notifies subscribers the message author
  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Rumbl.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: Rumbl.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        }
        {:reply, :ok, socket}

        {:error, changeset} ->
          {:reply, {:error, %{errors: changeset}}, socket}
    end
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