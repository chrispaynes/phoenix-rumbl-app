defmodule Rumbl.Auth do
  import Plug.Conn

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
end