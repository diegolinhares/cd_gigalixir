defmodule CdGigalixir.Orders.Data.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Products.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "items" do
    field :quantity, :integer
    belongs_to :product, Product
    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
