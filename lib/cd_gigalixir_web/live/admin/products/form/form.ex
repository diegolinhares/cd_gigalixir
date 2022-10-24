defmodule CdGigalixirWeb.Admin.Products.Form do
  use CdGigalixirWeb, :live_component
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product

  def update(assigns, socket) do
    changeset = Products.change_product()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(product: %Product{})}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end
