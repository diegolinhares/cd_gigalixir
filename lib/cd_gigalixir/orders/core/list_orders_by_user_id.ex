defmodule CdGigalixir.Orders.Core.ListOrdersByUserId do
  import Ecto.Query

  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Repo

  def execute(user_id) do
    Order
    |> where([o], o.user_id == ^user_id)
    |> order_by([o], desc: o.inserted_at)
    |> Repo.all()
  end
end
