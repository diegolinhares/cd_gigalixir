defmodule CdGigalixirWeb.Admin.Orders.OrderLive.Layer.CardTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "layer is loaded" do
    setup :register_and_log_in_admin

    test "render main elements", %{conn: conn} do
      card = %{id: Ecto.UUID.generate()}
      {:ok, view, _html} = live(conn, Routes.admin_order_path(conn, :index))
      assert has_element?(view, "#NOT_STARTED-#{card.id}")
    end
  end
end
