defmodule CdGigalixirWeb.Admin.ProductLive do
  use CdGigalixirWeb, :live_view
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product
  alias CdGigalixirWeb.Admin.Products.FilterByName
  alias CdGigalixirWeb.Admin.Products.Form
  alias CdGigalixirWeb.Admin.Products.ProductRow

  def mount(_assings, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    live_action = socket.assigns.live_action

    products = Products.list_products()

    socket =
      socket
      |> assign(products: products)
      |> assign(name: "")

    {:noreply, apply_action(socket, live_action, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _product} = Products.delete(id)

    {:noreply, assign(socket, :products, Products.list_products())}
  end

  def handle_event("filter-by-name", %{"name" => name}, socket) do
    socket = apply_filters(socket, name)

    {:noreply, socket}
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

  def apply_filters(socket, name) do
    products = Products.list_products(name)
    socket |> assign(products: products, name: name)
  end
end
