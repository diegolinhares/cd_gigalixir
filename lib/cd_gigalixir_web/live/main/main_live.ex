defmodule CdGigalixirWeb.MainLive do
  use CdGigalixirWeb, :live_view

  def mount(_assigns, _session, socket) do
    {:ok, socket |> assign(name: "Diego")}
  end
end
