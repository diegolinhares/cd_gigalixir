defmodule CdGigalixirWeb.Admin.Orders.OrderLive.SideMenuTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "side menu is loaded" do
    setup :register_and_log_in_admin

    test "render main elements", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_order_path(conn, :index))
      assert has_element?(view, "#side-menu")
      assert has_element?(view, "[data-role=side-title]", "Orders")
      assert has_element?(view, "[data-role=all-orders]", "All")
      assert has_element?(view, "[data-role=all-orders-qty]", "30")

      assert has_element?(view, "[data-role=all-not-started]", "Not Started")
      assert has_element?(view, "[data-role=all-not-started-qty]", "3")

      assert has_element?(view, "[data-role=all-received]", "Received")
      assert has_element?(view, "[data-role=all-received-qty]", "3")

      assert has_element?(view, "[data-role=all-preparing]", "Preparing")
      assert has_element?(view, "[data-role=all-preparing-qty]", "3")

      assert has_element?(view, "[data-role=all-delivering]", "Delivering")
      assert has_element?(view, "[data-role=all-delivering-qty]", "3")

      assert has_element?(view, "[data-role=all-delivered]", "Delivered")
      assert has_element?(view, "[data-role=all-delivered-qty]", "3")
    end
  end
end
