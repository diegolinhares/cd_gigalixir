defmodule CdGigalixirWeb.Admin.Products.Form do
  use CdGigalixirWeb, :live_component
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product

  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(product: product)}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    action = socket.assigns.action
    save(socket, action, product_params)
  end

  def save(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product was created")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def save(socket, :edit, product_params) do
    product = socket.assigns.product

    case Products.update_product(product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product was updated")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
