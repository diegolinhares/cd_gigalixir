defmodule CdGigalixirWeb.Admin.Show.ShowTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "test show" do
    setup :register_and_log_in_admin

    test "load page", %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_show_path(conn, :show, product))

      assert has_element?(view, "[data-role=product-description]", product.description)
      assert has_element?(view, "[data-role=product-name]", product.name)
      assert has_element?(view, "[data-role=product-size]", product.size)
      assert has_element?(view, "[data-role=product-price]", product.price |> Money.to_string())
    end
  end
end
