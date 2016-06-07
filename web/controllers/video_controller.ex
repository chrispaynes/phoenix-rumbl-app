defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller
  alias Rumbl.Video
  alias Rumbl.Category

  #VideoController Pipeline
  #checks and transforms empty strings into nil for “video” parameter data
  plug :scrub_params, "video" when action in [:create, :update]
  plug :load_categories when action in [:new, :create, :edit, :update]
  

  # displays all videos scoped to user
  def index(conn, _params, user) do
    videos = Repo.all(user_videos(user))
    render(conn, "index.html", videos: videos)
  end

  # creates changeset that pipes user
  # associates current_user with :videos
  # pipes current_user through video changeset
  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:videos)
      |> Video.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  # associates every newly created video to the current user
  def create(conn, %{"video" => video_params}, user) do
    changeset =
      user
      |> build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # displays a video — based on id — scoped to user
  def show(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  # returns all videos scoped to user
  defp user_videos(user) do
    assoc(user, :videos)
  end

  # creates load_categories plug based on functions in Category model
  # builds a query and passes it to Repo
  defp load_categories(conn, _) do
    query =
      Category
      |> Category.alphabetical
      |> Category.names_and_ids
    categories = Repo.all query
    assign(conn, :categories, categories)
  end

  # modifies default controller action -- this should be last in the module pipeline
  # applies every actions of the current session user to the module
  def action(conn, _)do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

end
