defmodule CdGigalixirWeb.CartLive.EmptyCart do
  use CdGigalixirWeb, :live_component

  def mount(_assigns, _session, socket) do
    {:ok, socket}
  end
end
