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
    assigns = [products: products, name: "", loading: false]

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(assigns)

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _product} = Products.delete(id)

    {:noreply, assign(socket, :products, Products.list_products())}
  end

  def handle_event("filter-by-name", %{"name" => name}, socket) do
    socket = apply_filters(socket, name)

    {:noreply, socket}
  end

  def handle_info({:list_products, name}, socket) do
    {:noreply, perform_filter(socket, name)}
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

  defp apply_filters(socket, name) do
    assigns = [products: [], name: name, loading: true]
    send(self(), {:list_products, name})
    socket |> assign(assigns)
  end

  defp perform_filter(socket, name) do
    name
    |> Products.list_products()
    |> return_filter_response(socket, name)
  end

  defp return_filter_response([], socket, name) do
    assigns = [loading: false, products: []]

    socket
    |> put_flash(:info, "There's no product with #{name}")
    |> assign(assigns)
  end

  defp return_filter_response(products, socket, _name) do
    assigns = [loading: false, products: products]

    socket
    |> assign(assigns)
  end
end
