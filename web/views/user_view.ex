defmodule Rumbl.UserView do
    use Rumbl.Web, :view
    alias Rumbl.User

    def first_name(%User{name: name}) do
        name 
        |> String.split(" ")
        |> Enum.at(0)
    end

    # renders user.json to view user's who submit annotation in chat
    def render("user.json", %{user: user}) do
      %{id: user.id, username: user.username}
    end 
end