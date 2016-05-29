defmodule Rumbl.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  # does not add null categories 
  def change do
    create table(:categories) do
      add :name, :string, null: false

      timestamps
    end

    # creates a unique index for a category name
    create unique_index(:categories, [:name])

  end
end
