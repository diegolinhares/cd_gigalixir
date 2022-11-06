defmodule CdGigalixirWeb.Admin.OrderLive.Layer do
  use CdGigalixirWeb, :live_component

  alias CdGigalixirWeb.Admin.OrderLive.Layer.Card

  @status [:NOT_STARTED, :DELIVERED]

  def update(assigns, socket) do
    cards = [
      %{
        id: Ecto.UUID.generate(),
        updated_at: DateTime.utc_now(),
        status: @status |> Enum.shuffle() |> hd,
        user: %{email: "troll@troll.com"},
        total_quantity: 20,
        total_price: Money.new(100_000),
        items: [
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{
              name: "Abobora",
              price: Money.new(200)
            }
          },
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{
              name: "Abobora 2",
              price: Money.new(200)
            }
          },
          %{
            id: Ecto.UUID.generate(),
            quantity: 10,
            product: %{
              name: "Abobora 3",
              price: Money.new(200)
            }
          }
        ]
      }
    ]

    socket =
      socket
      |> assign(assigns)
      |> assign(cards: cards)

    {:ok, socket}
  end
end
