defmodule CdGigalixirWeb.Admin.OrderLive.SideMenu do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Orders

  def update(assigns, socket) do
    order_status = Orders.all_status_orders()

    socket =
      socket
      |> assign(assigns)
      |> assign(order_status: order_status)

    {:ok, socket}
  end
end
