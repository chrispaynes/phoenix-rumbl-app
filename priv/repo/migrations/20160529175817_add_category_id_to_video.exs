defmodule Rumbl.Repo.Migrations.AddCategoryIdToVideo do
  use Ecto.Migration

  # makes database enforce constraint between videos and categories
  def change do
    alter table(:videos) do
      add :category_id, references(:categories)
    end
  end

end