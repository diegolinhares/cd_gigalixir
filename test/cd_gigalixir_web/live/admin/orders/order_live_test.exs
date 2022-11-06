defmodule CdGigalixirWeb.Admin.Orders.OrderLiveTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "order is loaded" do
    setup :register_and_log_in_admin

    test "render main elements", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_order_path(conn, :index))
      assert has_element?(view, "#side-menu")

      assert has_element?(view, "[data-role=layers]")

      assert has_element?(view, "#NOT_STARTED")
      assert has_element?(view, "#RECEIVED")
      assert has_element?(view, "#PREPARING")
      assert has_element?(view, "#DELIVERING")
      assert has_element?(view, "#DELIVERED")
    end
  end
end
