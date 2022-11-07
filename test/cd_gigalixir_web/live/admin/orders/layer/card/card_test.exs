defmodule CdGigalixirWeb.Admin.Orders.OrderLive.Layer.CardTest do
  use CdGigalixirWeb.ConnCase
  import CdGigalixir.Factory
  import Phoenix.LiveViewTest

  describe "card is loaded" do
    setup :register_and_log_in_admin

    test "render main elements", %{conn: conn} do
      card = insert(:order)
      {:ok, view, _html} = live(conn, Routes.admin_order_path(conn, :index))
      assert has_element?(view, "##{card.id}")
      assert has_element?(view, "[data-role=card-number][data-id=#{card.id}]", card.id)

      assert has_element?(
               view,
               "[data-role=list-items-title][data-id=#{card.id}]",
               "Order Items"
             )

      Enum.each(card.items, fn item ->
        assert has_element?(view, "[data-role=item][data-id=#{card.id}#{item.id}]")

        assert has_element?(
                 view,
                 "[data-role=item-description][data-id=#{card.id}#{item.id}]",
                 Integer.to_string(item.quantity)
               )
      end)

      assert has_element?(
               view,
               "[data-role=list-description-title][data-id=#{card.id}]",
               "Order description"
             )

      assert has_element?(
               view,
               "[data-role=total-price][data-id=#{card.id}]",
               "Total Price:"
             )

      assert has_element?(
               view,
               "[data-role=total-price-amount][data-id=#{card.id}]",
               Money.to_string(card.total_price)
             )

      assert has_element?(
               view,
               "[data-role=total-quantity-amount][data-id=#{card.id}]",
               Integer.to_string(card.total_quantity)
             )

      assert has_element?(
               view,
               "[data-role=total-quantity-amount][data-id=#{card.id}]",
               Integer.to_string(card.total_quantity)
             )

      assert has_element?(
               view,
               "[data-role=customer][data-id=#{card.id}]",
               "Customer:"
             )
    end
  end
end
