defmodule CdGigalixirWeb.CartLive.CartDetail.Item do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Carts
  alias CdGigalixir.Products

  def handle_event("dec", _, socket) do
    socket
    |> update_cart(&Carts.dec/2)

    {:noreply, socket}
  end

  def handle_event("inc", _, socket) do
    socket
    |> update_cart(&Carts.inc/2)

    {:noreply, socket}
  end

  def handle_event("remove", _, socket) do
    socket
    |> update_cart(&Carts.remove/2)

    {:noreply, socket}
  end

  defp update_cart(%{assigns: %{cart_id: cart_id, id: product_id}} = _socket, function) do
    cart = function.(cart_id, product_id)
    send(self(), {:update, cart})
  end
end
