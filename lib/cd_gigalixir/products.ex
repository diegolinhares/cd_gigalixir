defmodule CdGigalixir.Products do
  alias CdGigalixir.Products.Product
  alias CdGigalixir.Repo

  def list_products, do: Repo.all(Product)

  def create_product(attrs \\ %{}) do
    attrs
    |> Product.changeset()
    |> Repo.insert()
  end
end
