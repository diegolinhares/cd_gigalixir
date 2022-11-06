defmodule CdGigalixir.Orders.Core.ListOrdersByUserIdTest do
  use CdGigalixir.DataCase

  import CdGigalixir.Factory

  alias CdGigalixir.Orders.Core.ListOrdersByUserId

  test "return order by status" do
    order = insert(:order)
    assert 1 == ListOrdersByUserId.execute(order.user_id) |> Enum.count()
  end
end
