defmodule CdGigalixirWeb.Admin.Products.FormTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load modal to insert project", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=project-form]")

    assert view
           |> form("#new_product", product: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"
  end
end
