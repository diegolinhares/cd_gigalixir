defmodule CdGigalixir.Factory do
  use ExMachina.Ecto, repo: CdGigalixir.Repo

  alias CdGigalixir.Products.Product
  alias Faker.Food

  def product_factory do
    %Product{
      description: Food.description(),
      name: Food.dish(),
      price: 200,
      size: "small"
    }
  end
end
