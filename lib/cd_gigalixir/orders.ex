defmodule CdGigalixir.Orders do
  alias CdGigalixir.Orders.Core.{
    AllStatusOrders,
    CreateOrderByCart,
    GetOrderByIdAndCustomerId,
    ListOrdersByStatus,
    ListOrdersByUserId,
    UpdateOrderStatus
  }

  alias CdGigalixir.Orders.Data.Order

  alias CdGigalixir.Orders.Events.{
    NewOrder,
    UpdateOrder
  }

  defdelegate subscribe_to_receive_new_orders, to: NewOrder, as: :subscribe
  defdelegate subscribe_admin_orders_update, to: UpdateOrder
  defdelegate subscribe_update_user_row(user_id), to: UpdateOrder
  defdelegate subscribe_update_order(order_id), to: UpdateOrder

  defdelegate all_status_orders, to: AllStatusOrders, as: :execute
  defdelegate create_order_by_cart(payload), to: CreateOrderByCart, as: :execute

  defdelegate get_order_by_id_and_customer_id(order_id, customer_id),
    to: GetOrderByIdAndCustomerId,
    as: :execute

  defdelegate update_order_status(order_id, old_status, new_status),
    to: UpdateOrderStatus,
    as: :execute

  defdelegate list_orders_by_status(status), to: ListOrdersByStatus, as: :execute
  defdelegate list_orders_by_user_id(user_id), to: ListOrdersByUserId, as: :execute

  def get_status_list do
    Order
    |> Ecto.Enum.values(:status)
    |> Enum.with_index()
  end
end
