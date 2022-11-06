defmodule CdGigalixirWeb.CartLive.CartDetail.ConfirmOrder do
  use CdGigalixirWeb, :live_component

  alias CdGigalixir.Orders

  def handle_event("create-order", params, socket) do
    case Orders.create_order_by_cart(params) do
      {:ok, _order} ->
        socket =
          socket
          |> put_flash(:info, "Order created with success")
          |> push_redirect(to: Routes.customer_order_path(socket, :index))

        {:noreply, socket}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(:error, "Something went wrong please verify your order")
          |> push_redirect(to: Routes.cart_path(socket, :index))

        {:noreply, socket}
    end
  end
end
