defmodule Rumbl.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  # add :user_id, references(:users, on_delete: :nothing) adds a foreign key to link to :users unique index
  def change do
    create table(:videos) do
      add :url, :string
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:videos, [:user_id])

  end
end
