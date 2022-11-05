defmodule CdGigalixirWeb.CartLive.EmptyCartTest do
  use CdGigalixirWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load empty page", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.cart_path(conn, :index))

    assert has_element?(view, "[data-role=head-empty-cart]", "Your cart is empty!")

    assert has_element?(
             view,
             "[data-role=description-tip]",
             "You probably haven't ordered a food yet"
           )

    assert has_element?(
             view,
             "[data-role=description-tip]",
             "To order a food, go to the main page."
           )

    assert has_element?(view, "[data-role=go-main-page]", "Go back")
  end

  test "should go back to main page", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.cart_path(conn, :index))

    {:ok, view, _html} =
      view
      |> element("[data-role=go-main-page]", "Go back")
      |> render_click()
      |> follow_redirect(conn, Routes.main_path(conn, :index))

    assert has_element?(view, "[data-id=recommendation]", "Make your order")
  end
end
