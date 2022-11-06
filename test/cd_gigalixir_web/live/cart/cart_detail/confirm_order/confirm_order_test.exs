defmodule CdGigalixirWeb.CartDetail.ConfirmOrderTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "load page" do
    setup :register_and_log_in_user

    test "should create an order", %{conn: conn} do
      product = insert(:product)

      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)

      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      {:ok, _view, html} =
        view
        |> form("#confirm-order-form", %{
          "phone_number" => "124",
          "address" => "124"
        })
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_order_path(conn, :index))

      assert html =~ "Order created with success"
    end

    test "error to create order", %{conn: conn} do
      product = insert(:product)

      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)

      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      {:ok, _view, html} =
        view
        |> form("#confirm-order-form", %{})
        |> render_submit()
        |> follow_redirect(conn, Routes.cart_path(conn, :index))

      assert html =~ "Something went wrong please verify your order"
    end
  end

  defp build_product_element(product_id),
    do: "[data-role=product-add][data-id=item-#{product_id}]"

  defp add_product(view, product_element, conn) do
    {:ok, view, _html} =
      view
      |> element(product_element)
      |> render_click()
      |> follow_redirect(conn, Routes.main_path(conn, :index))

    view
  end
end
