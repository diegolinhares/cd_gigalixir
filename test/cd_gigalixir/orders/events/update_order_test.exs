defmodule CdGigalixir.Orders.Events.UpdateOrderTest do
  use CdGigalixir.DataCase

  alias CdGigalixir.Orders.Events.UpdateOrder

  test "should subscribe to receive admin order updates events" do
    UpdateOrder.subscribe_admin_orders_update()
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_admin_orders_update({:ok, %{status: :PREPARING}}, :RECEIVED)

    assert {:messages, [{:order_updated, %{status: :PREPARING}, :RECEIVED}]} ==
             Process.info(self(), :messages)
  end

  test "should subscribe to receive user row update events" do
    user_id = "123"
    UpdateOrder.subscribe_update_user_row(user_id)
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_update_user_row({:ok, %{status: :PREPARING, user_id: user_id}})

    assert {
             :messages,
             [
               update_order_user_row: %{
                 status: :PREPARING,
                 user_id: "123"
               }
             ]
           } == Process.info(self(), :messages)
  end

  test "should subscribe to receive order update events" do
    order_id = "123"
    UpdateOrder.subscribe_update_order(order_id)
    assert {:messages, []} == Process.info(self(), :messages)

    UpdateOrder.broadcast_update_order({:ok, %{status: :PREPARING, id: order_id}})

    assert {
             :messages,
             [
               update_order: %{
                 status: :PREPARING,
                 id: "123"
               }
             ]
           } == Process.info(self(), :messages)
  end
end
