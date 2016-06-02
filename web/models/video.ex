defmodule Rumbl.Video do
  use Rumbl.Web, :model

  # customizes primary key with Rumbl.Permalink
  @primary_key {:id, Rumbl.Permalink, autogenerate: true}

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :slug, :string
    belongs_to :user, Rumbl.User
    # creates belongs-to relationship for optional category_id field
    belongs_to :category, Rumbl.Category

    timestamps
  end

  @required_fields ~w(url title description)
  # creates new optional field for a category_id
  @optional_fields ~w(category_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  # creates video only if the category exists in the database
  # passes model through to creates a slug from the title
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> slugify_title()
    |> assoc_constraint(:category)
  end

  # creates a slug from the title field
  # if the changeset modifies the title, a new slug is generated
  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  # implements Phoenix.Param for Rumbl.Video
  # pattern matches video slug and ID
  # builds a string from matched patter
  defimpl Phoenix.Param, for: Rumbl.Video do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end

end
