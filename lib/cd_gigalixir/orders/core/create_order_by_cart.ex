defmodule CdGigalixir.Oders.Core.CreateOrderByCart do
  alias CdGigalixir.Carts
  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Orders.Events.NewOrder
  alias CdGigalixir.Repo

  def execute(%{"current_user" => current_user} = payload) do
    current_user
    |> Carts.get()
    |> convert_session_to_payload_item()
    |> create_order_payload(payload)
    |> Repo.insert()
    |> NewOrder.broadcast()
    |> remove_cache()
  end

  defp convert_session_to_payload_item(%{items: items} = cart) do
    payload_items = Enum.map(items, &%{quantity: &1.qty, product_id: &1.item.id})
    {cart, payload_items}
  end

  defp create_order_payload({cart, items}, payload) do
    changeset = %{
      user_id: payload["current_user"],
      address: payload["address"],
      phone_number: payload["phone_number"],
      item: items,
      total_quantity: cart.total_qty,
      total_price: cart.total_price
    }

    Order.changeset(%Order{}, changeset)
  end

  defp remove_cache({:error, _} = error), do: error

  defp remove_cache({:ok, order} = result) do
    Carts.delete_cart(order.user_id)
    result
  end
end
