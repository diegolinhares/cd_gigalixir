defmodule CdGigalixir.Orders.Data.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias CdGigalixir.Accounts.User
  alias CdGigalixir.Orders.Data.Item

  @status_values ~w/NOT_STARTED RECEIVED PREPARING DELIVERING DELIVERED/a
  @fields ~w/status/a
  @required_fields ~w/total_price total_quantity user_id address phone_number/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "orders" do
    field :status, Ecto.Enum, values: @status_values, default: :NOT_STARTED
    field :total_price, Money.Ecto.Amount.Type
    field :total_quantity, :integer
    field :address, :string
    field :phone_number, :string

    has_many :items, Item
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:total_quantity, greater_than: 0)
    |> cast_assoc(:items, with: &Item.changeset/2)
  end
end
