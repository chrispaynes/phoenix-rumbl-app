defmodule Rumbl.Permalink do
  @behaviour Ecto.Type

  def type, do: :id 

  # cast functions are called when data is passed into Ecto
  # parses binary into an integer
  # the string must start with a positive integer
  # negative integers work when not a string
  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  # returns ok and integer when an integer is supplied
  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # raises error if an integer is not passed in
  def cast(_) do
    :error
  end

  # invoked when data is sent to database
  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # invoked when data is loaded from database
  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end  

end