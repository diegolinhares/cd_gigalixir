defmodule CdGigalixirWeb.CartLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Carts
  alias CdGigalixirWeb.CartLive.CartDetail
  alias CdGigalixirWeb.CartLive.EmptyCart

  def mount(_assigns, _session, socket) do
    cart_id = socket.assigns.cart_id
    cart = Carts.get(cart_id)

    socket =
      socket
      |> assign(cart: cart)

    {:ok, socket}
  end

  def handle_info({:update, cart}, socket) do
    {:noreply, assign(socket, cart: cart)}
  end
end
