# struct is an ELX abstraction for working with structured data
# structs are built upon maps
# structs help overcome a pitfall of maps
# maps only protect against misspelled key values accessed at runtime
# structs indicate errors earlier during compilation
# structs fills in remaining values for keys without a value

defmodule Rumbl.User do
    defstruct [:id, :name, :username, :password]
end