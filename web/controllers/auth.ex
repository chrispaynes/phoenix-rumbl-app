defmodule Rumbl.Auth do
  import Plug.Conn
  # checkpw checks the password
  # dummy_checkpw simulates a password check with variable timing
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  # raises exception if :repo does not exist
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  # receives the repo from init
  # checks if user_id is stored in session
  # assigns session user_id and user_id from repo to the current user
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user    = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user)
  end

  # receives conn and user and stores user id in session
  # sends session cookie back to client with new identifier
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
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

end