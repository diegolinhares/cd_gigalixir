defmodule CdGigalixirWeb.Admin.Products.FormTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest
  import CdGigalixir.Factory

  alias CdGigalixir.Products

  describe "test product form" do
    setup :register_and_log_in_admin

    test "load modal to insert project", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      open_modal(view)

      assert has_element?(view, "[data-role=modal]")
      assert has_element?(view, "[data-role=project-form]")

      assert view
             |> form("#new", product: %{name: nil})
             |> render_change() =~ "can&#39;t be blank"
    end

    test "given a product that already exists when try to update without data returns an error",
         %{
           conn: conn
         } do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert view
             |> element("[data-role=edit-product][data-id=#{product.id}]")
             |> render_click()

      assert_patch(view, Routes.admin_product_path(conn, :edit, product))

      assert view
             |> form("##{product.id}", product: %{name: nil})
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "given a product when submit the form then return a message saying project was created",
         %{
           conn: conn
         } do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      open_modal(view)

      payload = %{name: "melao", description: "abc123", price: 123, size: "small"}

      {:ok, _view, html} =
        view
        |> form("#new", product: payload)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

      assert html =~ "Product was created"
      assert html =~ payload.name
    end

    test "given a product when submit the form then return a changeset error", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      open_modal(view)
      payload = %{name: "melao", description: "abc123", price: 123, size: "small"}

      assert {:ok, _product} = Products.create_product(payload)

      assert view
             |> form("#new", product: payload)
             |> render_submit() =~ "has already been taken"
    end

    test "given a created product when submit the form opens the modal and execute the action", %{
      conn: conn
    } do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert view
             |> element("[data-role=edit-product][data-id=#{product.id}]")
             |> render_click()

      assert view
             |> has_element?("#modal")

      assert_patch(view, Routes.admin_product_path(conn, :edit, product))

      assert view
             |> form("##{product.id}", product: %{name: nil})
             |> render_change() =~ "can&#39;t be blank"

      {:ok, view, html} =
        view
        |> form("##{product.id}", product: %{name: "aboboras"})
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

      assert html =~ "Product was updated"

      assert view
             |> has_element?("[data-role=product-name][data-id=#{product.id}]", "aboboras")
    end

    test "should cancel upload", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :new))

      upload =
        file_input(view, "#new", :photo, [
          %{
            last_modified: 1_594_171_879_000,
            name: "myfile.jpeg",
            content: "   ",
            type: "image/jpeg"
          }
        ])

      assert render_upload(upload, "myfile.jpeg", 100) =~ "100%"

      assert has_element?(
               view,
               "[data-role=image-loaded][data-id=#{hd(upload.entries)["ref"]}]",
               "100"
             )

      ref = "[data-role=cancel][data-id=#{hd(upload.entries)["ref"]}]"
      assert has_element?(view, ref)
      assert element(view, ref) |> render_click()
      refute has_element?(view, ref)
    end
  end

  defp open_modal(view) do
    view
    |> element("[data-role=add-new-product]", "New")
    |> render_click()
  end
end
