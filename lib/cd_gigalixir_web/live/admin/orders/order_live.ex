defmodule CdGigalixirWeb.Admin.OrderLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Orders
  alias CdGigalixirWeb.Admin.OrderLive.Layer
  alias CdGigalixirWeb.Admin.OrderLive.SideMenu

  def mount(_assings, _session, socket) do
    if connected?(socket) do
      Orders.subscribe_admin_orders_update()
      Orders.subscribe_to_receive_new_orders()
    end

    {:ok, socket}
  end
end
