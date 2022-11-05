defmodule CdGigalixirWeb.CartLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Carts
  alias CdGigalixirWeb.CartLive.CartDetail
  alias CdGigalixirWeb.CartLive.EmptyCart

  def mount(_assigns, _session, socket) do
    cart_id = socket.assigns.cart_id
    cart = Carts.get(cart_id)

    IO.inspect(cart)

    socket =
      socket
      |> assign(cart: cart)

    {:ok, socket}
  end
end
