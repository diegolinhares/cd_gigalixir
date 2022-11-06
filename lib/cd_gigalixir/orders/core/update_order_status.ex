defmodule CdGigalixir.Orders.Core.UpdateOrderStatus do
  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Orders.Events.UpdateOrder
  alias CdGigalixir.Repo

  def execute(order_id, old_status, new_status) do
    Order
    |> Repo.get(order_id)
    |> Order.changeset(%{status: new_status})
    |> Repo.update()
    |> UpdateOrder.broadcast_admin_orders_update(old_status)
    |> UpdateOrder.broadcast_update_order()
    |> UpdateOrder.broadcast_update_user_row()
  end
end
