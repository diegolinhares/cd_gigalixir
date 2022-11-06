defmodule CdGigalixir.Orders.Events.NewOrder do
  alias Phoenix.PubSub

  @topic "new_order"
  @pub_sub CdGigalixir.PubSub

  def subscribe, do: PubSub.subscribe(@pub_sub, @topic)

  def broadcast({:error, _} = error), do: error

  def broadcast({:ok, order} = result) do
    PubSub.broadcast(@pub_sub, @topic, {:new_order, order})
    result
  end
end
