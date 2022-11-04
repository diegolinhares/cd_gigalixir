defmodule CdGigalixir.Application do
  use Application
  alias CdGigalixir.Carts.Boundary.CartSession

  @impl true
  def start(_type, _args) do
    children = [
      CdGigalixir.Repo,
      CdGigalixirWeb.Telemetry,
      {Phoenix.PubSub, name: CdGigalixir.PubSub},
      CdGigalixirWeb.Endpoint,
      CartSession
    ]

    opts = [strategy: :one_for_one, name: CdGigalixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CdGigalixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
