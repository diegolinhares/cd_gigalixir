defmodule CdGigalixir.Factory do
  use ExMachina.Ecto, repo: CdGigalixir.Repo

  alias CdGigalixir.Products.Product
  alias Faker.Food

  def product_factory do
    image = :rand.uniform(4)

    %Product{
      description: Food.description(),
      name: Food.dish(),
      price: :rand.uniform(10_000),
      size: "small",
      product_url: %Plug.Upload{
      content_type: "image/png",
      filename: "product_#{image}.png",
      path: "priv/static/images/product_#{image}.jpg"
    }
  }
  end
end
