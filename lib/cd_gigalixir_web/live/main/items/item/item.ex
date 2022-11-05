defmodule CdGigalixirWeb.Main.Items.Item do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Carts
  alias CdGigalixir.Products

  def handle_event("add", _, socket) do
    product = socket.assigns.product
    cart_id = socket.assigns.cart_id

    add_product_to_cart(cart_id, product)

    socket =
      socket
      |> put_flash(:info, "Item added to cart")
      |> push_redirect(to: "/")

    {:noreply, socket}
  end

  defp add_product_to_cart(cart_id, product) do
    Carts.add(cart_id, product)
  end
end
