defmodule CdGigalixirWeb.Admin.ProductLive do
  use CdGigalixirWeb, :live_view
  alias CdGigalixir.Products
  alias CdGigalixirWeb.Admin.Products.Form

  def mount(_assings, _session, socket) do
    products = Products.list_products()

    {:ok, socket |> assign(products: products)}
  end
end
