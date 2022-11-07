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
end
