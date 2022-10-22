defmodule CdGigalixirWeb.MainLive do
  use CdGigalixirWeb, :live_view

  alias CdGigalixirWeb.Main.Hero
  alias CdGigalixirWeb.Main.Items

  def mount(_assigns, _session, socket) do
    {:ok, socket |> assign(name: "Diego")}
  end
end
