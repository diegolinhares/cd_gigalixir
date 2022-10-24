defmodule CdGigalixir.ProductsTest do
  use CdGigalixir.DataCase
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product

  test "list_products/0" do
    assert Products.list_products() == []
  end

  test "create_product/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    assert {:ok, %Product{} = product} = Products.create_product(input)
    assert product.description == input.description
    assert product.name == input.name
    assert product.size == input.size
    assert product.price == input.price
  end
end
