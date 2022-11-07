defmodule CdGigalixirWeb.Customer.OrderLive.Status do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Orders

  def mount(_assings, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    if connected?(socket) do
      Orders.subscribe_update_order(id)
    end

    current_user = socket.assigns.current_user
    order = Orders.get_order_by_id_and_customer_id(id, current_user.id)
    status_list = Orders.get_status_list()
    current_status = get_current_status(order.status)

    socket =
      socket
      |> assign(order: order)
      |> assign(status_list: status_list)
      |> assign(current_status: current_status)

    {:noreply, socket}
  end

  def handle_info({:update_order_user_row, order}, socket) do
    current_status = get_current_status(order.status)
    {:noreply, socket |> assign(current_status: current_status)}
  end

  defp get_current_status(current_status) do
    Orders.get_status_list()
    |> Enum.find(fn {status, _index} -> status == current_status end)
    |> then(fn {_, value} -> value end)
  end
end
