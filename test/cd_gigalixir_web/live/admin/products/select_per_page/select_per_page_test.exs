defmodule CdGigalixirWeb.Admin.Products.SelectPerPageTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "test select per page" do
    setup :register_and_log_in_admin

    test "filtering results per page", %{conn: conn} do
      for _ <- 1..10, do: insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "[id=select-per-page]")

      view
      |> form("#per-page")
      |> render_change(%{"per-page-select" => "5"})
    end
  end
end
