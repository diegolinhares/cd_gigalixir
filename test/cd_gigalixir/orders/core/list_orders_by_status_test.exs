defmodule CdGigalixir.Orders.Core.ListOrdersByStatusTest do
  use CdGigalixir.DataCase

  import CdGigalixir.Factory

  alias CdGigalixir.Orders.Core.ListOrdersByStatus

  test "return order by status" do
    insert(:order)
    assert 1 == ListOrdersByStatus.execute(:NOT_STARTED) |> Enum.count()
  end
end
