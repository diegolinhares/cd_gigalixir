defmodule CdGigalixir.Factory do
  use ExMachina.Ecto, repo: CdGigalixir.Repo

  alias CdGigalixir.Products.Product
  alias Faker.Food

  def product_factory do
    %Product{
      description: Food.description(),
      name: Food.dish() <> " #{:rand.uniform(10_000)}",
      price: :rand.uniform(10_000),
      size: "small"
    }
  end
end
