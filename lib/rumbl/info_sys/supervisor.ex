defmodule Rumbl.InfoSys.Supervisor do
  use Supervisor

  # starts the supervisor
  # picks up the current module's name
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # initializes the workers
  # begins worker supervision
  def init(_opts) do
    children = [
      worker(Rumbl.InfoSys, [], restart: :temporary)
    ]

    supervise children, strategy: :simple_one_for_one
  end
end