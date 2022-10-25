defmodule CdGigalixir.ProductsTest do
  use CdGigalixir.DataCase
  alias CdGigalixir.Products
  alias CdGigalixir.Products.Product

  test "list_products/0" do
    assert Products.list_products() == []
  end

  test "get!/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}
    {:ok, product} = Products.create_product(input)

    assert Products.get!(product.id).name == product.name
  end

  test "create_product/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    assert {:ok, %Product{} = product} = Products.create_product(input)
    assert product.description == input.description
    assert product.name == input.name
    assert product.size == input.size
    assert product.price == %Money{amount: 100, currency: :BRL}
  end

  test "create_product/1 given a product with the same name should throw an error message" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    assert {:ok, %Product{} = _product} = Products.create_product(input)
    assert {:error, changeset} = Products.create_product(input)
    assert "has already been taken" in errors_on(changeset).name
    assert %{name: ["has already been taken"]} = errors_on(changeset)
  end

  test "update_product/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    {:ok, product} = Products.create_product(input)
    {:ok, %Product{} = product} = Products.update_product(product, %{name: "abobora"})

    assert product.name == "abobora"
  end
end
