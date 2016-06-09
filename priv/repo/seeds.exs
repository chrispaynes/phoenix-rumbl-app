# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rumbl.Repo
# alias Rumbl.Category
alias Rumbl.User

Repo.insert!(%User{name: "Wolfram", username: "wolfram"})

# traverses through category name list
# retrieves the category name if already present OR
# writes the new category to the database
# for category <- ~w(Action Drama Romance Comedy Sci-fi) do
#   Repo.get_by(Category, name: category) ||
#     Repo.insert!(%Category{name: category})
# end