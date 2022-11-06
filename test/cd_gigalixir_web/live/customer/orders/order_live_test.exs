defmodule CdGigalixirWeb.Customer.Orders.OrderLiveTest do
  use CdGigalixirWeb.ConnCase

  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "order is loaded" do
    setup :register_and_log_in_user

    test "render when don't have orders", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.customer_order_path(conn, :index))
      assert has_element?(view, "[data-role=section-title]", "All orders")
      assert has_element?(view, "[data-role=no-orders]", "No orders found")
    end

    test "render when orders are present", %{conn: conn, user: user} do
      order = insert(:order, user: user)
      {:ok, view, _html} = live(conn, Routes.customer_order_path(conn, :index))
      assert has_element?(view, "##{order.id}")
      assert has_element?(view, "[data-role=show-status][data-id=#{order.id}]", order.id)

      assert has_element?(
               view,
               "[data-role=details][data-id=#{order.id}]",
               "#{order.address} - #{order.phone_number}"
             )

      assert has_element?(view, "[data-role=status][data-id=#{order.id}]", "Not started")

      assert has_element?(
               view,
               "[data-role=date][data-id=#{order.id}]",
               order.updated_at |> NaiveDateTime.to_string()
             )
    end
  end
end
