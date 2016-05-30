# structs are built upon maps built helpt overcome their pitfalls
# maps only protect against misspelled key values accessed at runtime
# structs indicate errors earlier during compilation
# structs fill in remaining values for keys without a value


# each user has a one-to-many relationship with a video
defmodule Rumbl.User do
  use Rumbl.Web, :model
      schema "users" do
        field :name, :string
        field :username, :string
        field :password, :string, virtual: true
        field :password_hash, :string
        has_many :videos, Rumbl.Video        

        timestamps
  end

  # defines the changeset action for users and usernames
  # pipes username model through casts to ensure name and username are supplied
  # validates username length is between 1 and 20 characters
  # data validation for the username
  # creates changeset error message when user creates duplicate username entry
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  # changeset to manage passwords
  # validates password length and hashes password
  # pipes through put_pass_hash() if changeset is valid
  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  # performs password hashing if the changeset is valid
  # checks users' passwords in as secure a manner as possible.
  # bcrypt is a password hashing function that incorporates a salt to protect against rainbow table attacks
  # `hashpwsalt` generates a salt and hashes the password.
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
        _ ->
        changeset
    end
  end

end
# this code was created prior to implementing an Ecto persisted PostgresDB
# defmodule Rumbl.User do
#     defstruct [:id, :name, :username, :password]
# end