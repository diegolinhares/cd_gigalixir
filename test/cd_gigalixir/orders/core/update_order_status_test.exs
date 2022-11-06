defmodule CdGigalixir.Orders.Core.UpdateOrderStatusTest do
  use CdGigalixir.DataCase

  import CdGigalixir.Factory

  alias CdGigalixir.Orders.Core.UpdateOrderStatus

  test "return order by status" do
    order = insert(:order)
    assert {:ok, result} = UpdateOrderStatus.execute(order.id, order.status, :DELIVERED)

    refute order.status == result.status
  end
end
