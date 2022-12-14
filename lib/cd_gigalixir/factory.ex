defmodule CdGigalixir.Factory do
  use ExMachina.Ecto, repo: CdGigalixir.Repo

  alias CdGigalixir.Accounts.User
  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Products.Product
  alias CdGigalixir.Repo
  alias Faker.Food

  @size ~w/small medium large/s

  def product_factory do
    %Product{
      description: Food.description(),
      name: Food.dish() <> " #{:rand.uniform(10_000)}",
      price: :rand.uniform(10_000),
      size: @size |> Enum.shuffle() |> hd
    }
  end

  def order_factory(attrs) do
    user =
      if attrs[:user] do
        attrs[:user]
      else
        %User{}
        |> User.registration_changeset(%{
          email: "test-#{:rand.uniform(10_000)}@elxpro.com",
          password: "adm@elxpro.comD1!"
        })
        |> Repo.insert!()
      end

    product_1 = insert(:product)
    product_2 = insert(:product)

    total_price = product_1.price |> Money.add(product_1.price) |> Money.add(product_2.price)

    %Order{
      user_id: user.id,
      address: Faker.Address.PtBr.street_address(),
      phone_number: Faker.Phone.PtBr.phone(),
      items: [
        %{quantity: 2, product_id: product_1.id},
        %{quantity: 1, product_id: product_2.id}
      ],
      total_quantity: 3,
      total_price: total_price
    }
  end
end
