# struct is an ELX abstraction for working with structured data
# structs are built upon maps
# structs help overcome a pitfall of maps
# maps only protect against misspelled key values accessed at runtime
# structs indicate errors earlier during compilation
# structs fills in remaining values for keys without a value

defmodule Rumbl.User do
  use Rumbl.Web, :model
      schema "users" do
        field :name, :string
        field :username, :string
        field :password, :string, virtual: true
        field :password_hash, :string

        timestamps
  end

  #defines the changeset action for users
  #pipes the username model through casts to ensure name and username are supplied
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
  end

end
# this code was created prior to implementing an Ecto persisted PostgresDB
# defmodule Rumbl.User do
#     defstruct [:id, :name, :username, :password]
# end