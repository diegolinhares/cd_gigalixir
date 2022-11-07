defmodule CdGigalixirWeb.Customer.OrderLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Orders
  alias CdGigalixirWeb.Customer.OrderLive.OrderRow

  def mount(_assings, _session, socket) do
    current_user = socket.assigns.current_user

    if connected?(socket) do
      Orders.subscribe_update_user_row(current_user.id)
    end

    orders = Orders.list_orders_by_user_id(current_user.id)
    {:ok, assign(socket, orders: orders)}
  end

  def handle_info({:update_order_user_row, order}, socket) do
    send_update(OrderRow, id: order.id, order: order)
    {:noreply, socket}
  end
end
