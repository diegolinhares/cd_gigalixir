defmodule CdGigalixirWeb.Main.ItemsTest do
  use CdGigalixirWeb.ConnCase

  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  test "load items", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.main_path(conn, :index))

    assert has_element?(view, "#items-component")
    assert has_element?(view, "[data-role=items-info][data-id=all-food]", "All Foods")
  end

  test "should load more elements", %{conn: conn} do
    products = for _ <- 0..12, do: insert(:product)

    {:ok, view, _html} = live(conn, Routes.main_path(conn, :index))

    [products_page_1, products_page_2] = products |> Enum.chunk_every(8)

    Enum.each(products_page_1, fn product ->
      assert has_element?(view, "#item-#{product.id}")
    end)

    Enum.each(products_page_2, fn product ->
      refute has_element?(view, "#item-#{product.id}")
    end)

    view
    |> element("#products-loading")
    |> render_hook("load-more", %{})

    Enum.each(products_page_2, fn product ->
      assert has_element?(view, "#item-#{product.id}")
    end)
  end

  test "add a new item on cart", %{conn: conn} do
    product = insert(:product)
    route = Routes.main_path(conn, :index)
    {:ok, view, _html} = live(conn, route)
    product_element = "[data-role=product-add][data-id=item-#{product.id}]"
    assert has_element?(view, product_element)

    {:ok, _view, html} =
      view
      |> element(product_element)
      |> render_click()
      |> follow_redirect(conn, route)

    assert html =~ "Item added to cart"
  end
end
