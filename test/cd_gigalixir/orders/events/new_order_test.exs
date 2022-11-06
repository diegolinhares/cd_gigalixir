defmodule CdGigalixir.Orders.Events.NewOrderTest do
  use CdGigalixir.DataCase

  import CdGigalixir.ProductFixtures
  alias CdGigalixir.Orders.Events.NewOrder

  test "should subscribe to receive new events" do
    NewOrder.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)
  end

  test "should receive broadcast message" do
    NewOrder.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)

    NewOrder.broadcast({:ok, %{id: "123"}})
    assert {:messages, [new_order: %{id: "123"}]} == Process.info(self(), :messages)
  end

  test "should receive error broadcast" do
    NewOrder.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)

    NewOrder.broadcast({:error, %{id: "123"}})
    assert {:messages, []} == Process.info(self(), :messages)
  end
end
