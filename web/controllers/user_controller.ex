defmodule Rumbl.UserController do
    use Rumbl.Web, :controller
    alias Rumbl.User    

    #sends connection through authenticate function plug when using :index or :show
    plug :authenticate_user when action in [:index, :show]

    def index(conn, _params) do
        users = Repo.all(Rumbl.User)
        render conn, "index.html", users: users
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get(Rumbl.User, id)
        render conn, "show.html", user: user
    end

    #creates changeset for a new user
      def new(conn, _params) do
        changeset = User.changeset(%User{})
        render conn, "new.html", changeset: changeset
      end    

    #creates a new user
    #reacts to {:error, changeset}
    #if the registration_changeset is valid, the new user is created, logged in and displayed
    #if the registration_changeset fails, the errors are rendered
    def create(conn, %{"user" => user_params}) do
      changeset = User.registration_changeset(%User{}, user_params)
      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> Rumbl.Auth.login(user)
          |> put_flash(:info, "#{user.name} created!")
          |> redirect(to: user_path(conn, :index))        
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
      # this was the default case, prior to validation
      # {:ok, user} = Repo.insert(changeset)
      # conn
      # |> put_flash(:info, "#{user.name} created!")
      # |> redirect(to: user_path(conn, :index))
    end

    # DEFP AUTHENTICATE MOVED TO AUTH.EX AS DEF AUTHENTICATE_USERS
    # function plug to restrict access to pages containing user index or user info
    # users must be logged in to view the index or user info
    # connects if there is a current user logged into the session
    # else halt any downstream plug transformations
    # flashes error message
    # defp authenticate(conn, _opts) do
    #   if conn.assigns.current_user do
    #     conn
    #   else
    #     conn
    #     |> put_flash(:error, "You must be logged in to access that page")
    #     |> redirect(to: page_path(conn, :index))
    #     |> halt()
    #   end
    # end

end