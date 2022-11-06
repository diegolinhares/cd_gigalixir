defmodule CdGigalixir.Orders.Core.GetOrderByIdAndCustomerIdTest do
  use CdGigalixir.DataCase

  import CdGigalixir.Factory

  alias CdGigalixir.Orders.Core.GetOrderByIdAndCustomerId

  test "return qty per status" do
    order = insert(:order)
    assert order.id == GetOrderByIdAndCustomerId.execute(order.id, order.user_id).id
  end
end
