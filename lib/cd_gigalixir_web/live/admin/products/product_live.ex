defmodule CdGigalixirWeb.Admin.ProductLive do
  use CdGigalixirWeb, :live_view
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product
  alias CdGigalixirWeb.Admin.Products.FilterByName
  alias CdGigalixirWeb.Admin.Products.Form
  alias CdGigalixirWeb.Admin.Products.ProductRow
  alias CdGigalixirWeb.Admin.Products.Sort

  def mount(_assings, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    name = params["name"] || ""
    sort_by = (params["sort_by"] || "updated_at") |> String.to_atom()
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()

    sort = %{sort_by: sort_by, sort_order: sort_order}
    live_action = socket.assigns.live_action

    products = Products.list_products(name: name, sort: sort)
    assigns = [products: products, name: "", loading: false, options: sort]

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
    sort = socket.assigns.options
    params = [name: name, sort: sort]

    {:noreply, perform_filter(socket, params)}
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

  defp perform_filter(socket, params) do
    params
    |> Products.list_products()
    |> return_filter_response(socket, params)
  end

  defp return_filter_response([], socket, params) do
    assigns = [loading: false, products: [], name: params[:name], options: params[:sort]]
    name = params[:name]

    socket
    |> put_flash(:info, "There's no product with #{name}")
    |> assign(assigns)
  end

  defp return_filter_response(products, socket, _params) do
    assigns = [loading: false, products: products]

    socket
    |> assign(assigns)
  end
end
