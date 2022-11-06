defmodule CdGigalixir.Orders.Core.ListOrdersByStatus do
  import Ecto.Query

  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Repo

  def execute(status) do
    Order
    |> where([o], o.status == ^status)
    |> order_by([o], desc: o.inserted_at)
    |> preload([o], [:user, items: [:product]])
    |> Repo.all()
  end
end
