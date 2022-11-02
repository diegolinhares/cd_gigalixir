defmodule CdGigalixirWeb.Admin.Products.FilterByNameTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "test filter" do
    setup :register_and_log_in_admin

    test "filter by name", %{conn: conn} do
      product_1 = insert(:product)
      product_2 = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "[data-role=product-item][data-id=#{product_1.id}]")
      assert has_element?(view, "[data-role=product-item][data-id=#{product_2.id}]")

      view
      |> form("#filter-by-name", %{name: product_1.name})
      |> render_submit()

      assert has_element?(view, "[data-role=product-item][data-id=#{product_1.id}]")
      refute has_element?(view, "[data-role=product-item][data-id=#{product_2.id}]")
    end

    test "filter by name without products", %{conn: conn} do
      product_1 = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "[data-role=product-item][data-id=#{product_1.id}]")

      view
      |> form("#filter-by-name", %{name: "Chikorita"})
      |> render_submit()

      refute has_element?(view, "[data-role=product-item]")
    end
  end
end
