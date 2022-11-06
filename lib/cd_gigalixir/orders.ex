defmodule CdGigalixir.Orders do
  alias CdGigalixir.Orders.Core.AllStatusOrders
  alias CdGigalixir.Orders.Events.NewOrder

  defdelegate subscribe_to_receive_new_orders, to: NewOrder, as: :subscribe
  defdelegate all_status_orders, to: AllStatusOrders, as: :execute
end
