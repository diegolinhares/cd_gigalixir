defmodule CdGigalixir.Products do
  alias CdGigalixir.Products.Product
  alias CdGigalixir.Products.ProductImage
  alias CdGigalixir.Repo

  import Ecto.Query

  def list_suggest_names(name) do
    name = "%" <> name <> "%"

    Product
    |> where([p], ilike(p.name, ^name))
    |> select([p], p.name)
    |> Repo.all()
  end

  def list_products(params \\ []) when is_list(params) do
    query = from(p in Product)

    params
    |> Enum.reduce(query, fn
      {:name, name}, query ->
        name = "%" <> name <> "%"
        where(query, [q], ilike(q.name, ^name))

      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query, offset: ^((page - 1) * per_page), limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        order_by(query, [q], [{^sort_order, ^sort_by}])
    end)
    |> Repo.all()
  end

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

  def get_image(product) do
    {product.product_url, product}
    |> ProductImage.url()
    |> get_image_url()
  end

  defp get_image_url(nil), do: ""

  defp get_image_url(url) do
    [_, image_url] = String.split(url, "/priv/static")
    image_url
  end
end
