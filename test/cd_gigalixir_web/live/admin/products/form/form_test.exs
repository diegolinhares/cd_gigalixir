defmodule CdGigalixirWeb.Admin.Products.FormTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  alias CdGigalixir.Products

  test "load modal to insert project", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=project-form]")

    assert view
           |> form("#new_product", product: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"
  end

  test "given a product when submit the form then return a message saying project was created", %{
    conn: conn
  } do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    payload = %{name: "melao", description: "abc123", price: 123, size: "small"}

    {:ok, _view, html} =
      view
      |> form("#new_product", product: payload)
      |> render_submit()
      |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

    assert html =~ "Product was created"
    assert html =~ payload.name
  end

  test "given a product when submit the form then return a changeset error", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    payload = %{name: "melao", description: "abc123", price: 123, size: "small"}

    assert {:ok, _product} = Products.create_product(payload)

    assert view
           |> form("#new_product", product: payload)
           |> render_submit() =~ "has already been taken"
  end
end
