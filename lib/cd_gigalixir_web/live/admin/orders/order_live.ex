defmodule CdGigalixirWeb.Admin.OrderLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixirWeb.Admin.OrderLive.Layer
  alias CdGigalixirWeb.Admin.OrderLive.SideMenu

  def mount(_assings, _session, socket) do
    {:ok, socket}
  end
end
