# Channel Module to process incoming events
defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel 
  alias Rumbl.AnnotationView

  # callback function authorizing or denying user channel access
  # assigns user to the socket matching the video ID
  # socket.assigns holds the state for the socket
  # stores the id for a user's last_seen video
  # OR stores a "0" id for new users who have not seen a video
  # returns annotations with id's greater than the last_seen_id
  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Repo.get!(Rumbl.Video, video_id)
    annotations = Repo.all(
      from a in assoc(video, :annotations),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )

    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")};

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
  def handle_in(event, params, socket) do
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
      {:ok, ann} ->
        broadcast_annotation(socket, ann)
        Task.start_link(fn -> compute_additional_info(ann, socket) end)
        {:reply, :ok, socket}

        {:error, changeset} ->
          {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Repo.preload(annotation, :user)
    rendered_ann = Phoenix.View.render(AnnotationView, "annotation.json", %{
      annotation: annotation
    })
    broadcast! socket, "new_annotation", rendered_ann
  end

  defp compute_additional_info(ann, socket) do
    for result <- Rumbl.InfoSys.compute(ann.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: ann.at}
      info_changeset =
      Repo.get_by!(Rumbl.User, username: result.backend)
      |> build_assoc(:annotations, video_id: ann.video_id)
      |> Rumbl.Annotation.changeset(attrs)

      case Repo.insert(info_changeset) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
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