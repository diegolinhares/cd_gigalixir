defmodule CdGigalixirWeb.CartDetail.Item.ItemTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "load page" do
    setup :register_and_log_in_user

    test "load two items components", %{conn: conn} do
      product = insert(:product)
      product_2 = insert(:product)

      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)

      product_element = build_product_element(product.id)
      product_2_element = build_product_element(product_2.id)

      view
      |> add_product(product_element, conn)
      |> add_product(product_element, conn)
      |> add_product(product_2_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      assert has_element?(view, get_product_item(product.id))
      assert has_element?(view, get_product_item(product_2.id))

      assert has_element?(view, get_product_name(product.id), product.name)
      assert has_element?(view, get_product_size(product.id), product.size)
      assert has_element?(view, get_product_qty(product.id), "2 item(s)")
      assert has_element?(view, get_product_price(product.id), Money.to_string(product.price))

      assert has_element?(view, get_product_name(product_2.id), product_2.name)
      assert has_element?(view, get_product_size(product_2.id), product_2.size)
      assert has_element?(view, get_product_qty(product_2.id), "1 item(s)")
      assert has_element?(view, get_product_price(product_2.id), Money.to_string(product_2.price))
    end

    test "decrement 1 item", %{conn: conn} do
      product = insert(:product)
      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)
      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      assert has_element?(view, get_product_item(product.id))
      assert has_element?(view, get_product_qty(product.id), "2 item(s)")

      dec(view, product.id)

      assert has_element?(view, get_product_qty(product.id), "1 item(s)")
    end

    test "decrement until remove", %{conn: conn} do
      product = insert(:product)
      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)
      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      assert has_element?(view, get_product_item(product.id))
      assert has_element?(view, get_product_qty(product.id), "2 item(s)")

      dec(view, product.id)
      dec(view, product.id)

      refute has_element?(view, get_product_item(product.id))
    end

    test "increment items", %{conn: conn} do
      product = insert(:product)
      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)
      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      assert has_element?(view, get_product_item(product.id))
      assert has_element?(view, get_product_qty(product.id), "2 item(s)")

      inc(view, product.id)

      assert has_element?(view, get_product_item(product.id), "3 item(s)")
    end

    test "remove items", %{conn: conn} do
      product = insert(:product)
      main_route = Routes.main_path(conn, :index)
      {:ok, view, _html} = live(conn, main_route)
      product_element = build_product_element(product.id)

      view
      |> add_product(product_element, conn)
      |> add_product(product_element, conn)

      cart_route = Routes.cart_path(conn, :index)
      {:ok, view, _html} = live(conn, cart_route)

      assert has_element?(view, get_product_item(product.id))
      assert has_element?(view, get_product_qty(product.id), "2 item(s)")

      remove(view, product.id)

      refute has_element?(view, get_product_item(product.id))
    end
  end

  defp get_product_item(product_id), do: "[data-role=order-item][data-id=#{product_id}]"
  defp get_product_name(product_id), do: "[data-role=order-name][data-id=#{product_id}]"
  defp get_product_size(product_id), do: "[data-role=order-size][data-id=#{product_id}]"
  defp get_product_qty(product_id), do: "[data-role=order-qty][data-id=#{product_id}]"
  defp get_product_price(product_id), do: "[data-role=order-price][data-id=#{product_id}]"

  defp dec(view, product_id) do
    view
    |> element("[data-role=dec][data-id=#{product_id}")
    |> render_click()
  end

  defp inc(view, product_id) do
    view
    |> element("[data-role=inc][data-id=#{product_id}")
    |> render_click()
  end

  defp remove(view, product_id) do
    view
    |> element("[data-role=remove][data-id=#{product_id}")
    |> render_click()
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
