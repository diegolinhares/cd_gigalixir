defmodule CdGigalixirWeb.Main.Items do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Products
  alias CdGigalixirWeb.Main.Items.Item

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(page: 1, per_page: 8)
      |> assign_products()

    {:ok, socket}
  end

  def handle_event("load-more", _params, socket) do
    socket = socket |> update(:page, &(&1 + 1)) |> assign_products()

    {:noreply, socket}
  end

  defp assign_products(socket) do
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    paginate = [{:paginate, %{page: page, per_page: per_page}}]
    products = Products.list_products(paginate)
    assign(socket, products: products)
  end
end
