defmodule CdGigalixirWeb.CartLiveTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, _view, html} = live(conn, Routes.cart_path(conn, :index))

    assert html =~ "Your cart is empty!"
  end
end
