defmodule CdGigalixirWeb.Admin.Orders.OrderLive.LayerTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "layer is loaded" do
    setup :register_and_log_in_admin

    test "render main elements", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_order_path(conn, :index))
      assert has_element?(view, "#NOT_STARTED")
      assert has_element?(view, "[data-role=layer-title][data-id=NOT_STARTED]", "Not started")

    end
  end
end
