defmodule Rumbl.Auth do
  import Plug.Conn
  # checkpw checks the password
  # dummy_checkpw simulates a password check with variable timing
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  alias Rumbl.Router.Helpers


  # function plug to restrict access to pages containing user index or user info
  # users must be logged in to view the index or user info
  # connects if there is a current user logged into the session
  # else halt any downstream plug transformations
  # flashes error message
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  # raises exception if :repo does not exist
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  # receives the repo from init
  # checks if user_id is stored in session
  # assigns session user_id and user_id from repo to the current user
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)
      user = user_id && repo.get(Rumbl.User, user_id) ->
        put_current_user(conn, user)
      true ->
        assign(conn, :current_user, nil)  
    end
  end

  # receives conn and user and stores user id in session
  # sends session cookie back to client with new identifier
  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  # places new user token and current user into conn.assigns
  # sets current user and user token when a user session exists
  # user_token holds the signed in ID user 
  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end


  # fetches repo
  # looks up username
  # if the username and password match repo, log in user
  # if user exists, but password does not match, return unauthorized
  # if the user does not exist, return not found
  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumbl.User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}  
    end
  end

  # deletes the current sessions
  def logout(conn) do
    # configure_session/2 is the default code from the Programming Phoenix Book
    # configure_session(conn, drop: true)
    
    # delete_session/2 allows us to use a put_flash message
    delete_session(conn, :user_id)
  end  

end