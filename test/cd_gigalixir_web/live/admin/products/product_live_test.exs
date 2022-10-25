defmodule CdGigalixirWeb.Admin.ProductLiveTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

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

    assert(
      has_element?(
        view,
        "[data-role=product-action][data-id=#{product.id}]",
        "Show | Edit | Delete"
      )
    )
  end
end
