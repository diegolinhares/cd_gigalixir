defmodule CdGigalixirWeb.Admin.OrderLive.Layer do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Orders
  alias CdGigalixirWeb.Admin.OrderLive.Layer.Card

  @status [:NOT_STARTED, :DELIVERED]

  def update(%{id: id} = assigns, socket) do
    cards = Orders.list_orders_by_status(id)

    socket =
      socket
      |> assign(assigns)
      |> assign(cards: cards)

    {:ok, socket}
  end

  def handle_event("dropped", %{"new_status" => new_status, "old_status" => old_status}, socket)
      when new_status == old_status do
    {:noreply, socket}
  end

  def handle_event("dropped", params, socket) do
    %{"order_id" => order_id, "new_status" => new_status, "old_status" => old_status} = params

    Orders.update_order_status(order_id, old_status, new_status)
    {:noreply, socket}
  end
end
