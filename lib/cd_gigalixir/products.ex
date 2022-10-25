defmodule CdGigalixir.Products do
  alias CdGigalixir.Products.Product
  alias CdGigalixir.Repo

  def list_products, do: Repo.all(Product)

  def create_product(attrs \\ %{}) do
    attrs
    |> Product.changeset()
    |> Repo.insert()
  end

  def change_product(product, params \\ %{}), do: Product.changeset(product, params)

  def get!(id), do: Repo.get!(Product, id)

  def delete(id) do
    id
    |> get!()
    |> Repo.delete()
  end

  def update_product(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end
end
