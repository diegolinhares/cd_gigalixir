defmodule CdGigalixirWeb.CartLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixirWeb.CartLive.EmptyCart

  def mount(_assigns, _session, socket) do
    {:ok, socket}
  end
end
