defmodule CdGigalixirWeb.Main.Items do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Products
  alias CdGigalixirWeb.Main.Items.Item

  def update(assigns, socket) do
    products = Products.list_products()

    socket =
      socket
      |> assign(assigns)
      |> assign(products: products)

    {:ok, socket}
  end
end
