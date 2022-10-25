defmodule CdGigalixirWeb.Admin.ProductLive.Show do
  use CdGigalixirWeb, :live_view

  alias CdGigalixir.Products

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    product = Products.get!(id)

    {:noreply,
     socket
     |> assign(product: product)
     |> assign(page_title: "Show")}
  end
end
