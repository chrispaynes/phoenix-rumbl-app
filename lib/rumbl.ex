defmodule Rumbl do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  # Starts the endpoint when the application starts
  # A child is started by the Elixir App
  # If hard coding a repo, comment out the ELixir supervisor and the worker.  
  def start(_type, _args) do
    import Supervisor.Spec, warn: true

    children = [
      supervisor(Rumbl.Endpoint, []),
      supervisor(Rumbl.InfoSys.Supervisor, []),
      supervisor(Rumbl.Repo, []),
      # worker(Rumbl.Counter, [5]),
      # Here you could define other workers and supervisors as children
      # worker(Rumbl.Worker, [arg1, arg2, arg3]),
      # worker(Rumbl.Counter, [5], restart: :permanent OR :temporary OR :transient),
    ]

    # this details the OTP Supervision Strategy
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    # ":one_for_one" indicates 1 child will be restarted if 1 dies
    # strategy: :one_for_all OR :one_for_one OR rest_for_one OR simple_one_for_one 
    opts = [strategy: :one_for_one, name: Rumbl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Rumbl.Endpoint.config_change(changed, removed)
    :ok
  end
end
