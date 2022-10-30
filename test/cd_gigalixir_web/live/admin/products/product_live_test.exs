defmodule CdGigalixirWeb.Admin.ProductLiveTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "test default page product" do
    setup :register_and_log_in_user

    test "load page", %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "[data-role=product-section]")
      assert has_element?(view, "[data-role=product-table]")
      assert has_element?(view, "[data-id=head-name]")
      assert has_element?(view, "[data-id=head-price]")
      assert has_element?(view, "[data-id=head-size]")
      assert has_element?(view, "[data-id=head-action]")
      assert has_element?(view, "[data-role=product-list]")
      assert has_element?(view, "[data-role=product-item][data-id=#{product.id}]")
      assert has_element?(view, "[data-role=product-name][data-id=#{product.id}]", product.name)
      assert has_element?(view, "[data-role=product-size][data-id=#{product.id}]", product.size)

      assert element(view, "[data-role=product-price][data-id=#{product.id}]")
            |> render =~ "#{product.price}"

      assert has_element?(view, "[data-role=product-action][data-id=#{product.id}]")
    end

    test "given a product that already exists when click to delete remove from db and update the list",
        %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "[data-role=delete-product][data-id=#{product.id}]", "Delete")

      assert view
            |> element("[data-role=delete-product][data-id=#{product.id}]", "Delete")
            |> render_click()

      refute has_element?(view, "[data-role=delete-product][data-id=#{product.id}]")
    end
  end
end
