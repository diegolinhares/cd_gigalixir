defmodule CdGigalixir.Orders do
  alias CdGigalixir.Orders.Events.NewOrder

  defdelegate subscribe_to_receive_new_orders, to: NewOrder, as: :subscribe
end
