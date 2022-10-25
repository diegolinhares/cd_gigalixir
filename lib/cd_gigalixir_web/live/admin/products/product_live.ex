defmodule CdGigalixirWeb.Admin.ProductLive do
  use CdGigalixirWeb, :live_view
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product
  alias CdGigalixirWeb.Admin.Products.Form

  def mount(_assings, _session, socket) do
    products = Products.list_products()

    {:ok, socket |> assign(products: products)}
  end

  def handle_params(params, _url, socket) do
    live_action = socket.assigns.live_action

    {:noreply, apply_action(socket, live_action, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _product} = Products.delete(id)

    {:noreply, assign(socket, :products, Products.list_products())}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "List Products")
    |> assign(:product, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create new Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    product = Products.get!(id)

    socket
    |> assign(:page_title, "Create new Product")
    |> assign(:product, product)
  end
end
