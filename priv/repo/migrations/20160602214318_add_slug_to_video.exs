defmodule Rumbl.Repo.Migrations.AddSlugToVideo do
  use Ecto.Migration

  # adds :slug string to database
  # the :slug is a human-readable identifier at the end of a URL
  def change do
    alter table(:videos) do
      add :slug, :string
    end
  end

end
