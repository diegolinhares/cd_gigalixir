defmodule CdGigalixir.ProductFixtures do
  alias CdGigalixir.Products
  alias Faker.Food

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: Food.description(),
        name: Food.dish(),
        price: 200,
        size: "small"
      })
      |> Products.create_product()

    product
  end
end
