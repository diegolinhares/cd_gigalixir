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

  test "delete/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}
    {:ok, product} = Products.create_product(input)

    assert {:ok, _product} = Products.delete(product.id)
    assert_raise Ecto.NoResultsError, fn -> Products.get!(product.id) end
  end

  test "create_product/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    assert {:ok, %Product{} = product} = Products.create_product(input)
    assert product.description == input.description
    assert product.name == input.name
    assert product.size == input.size
    assert product.price == %Money{amount: 100, currency: :BRL}
    assert "" == Products.get_image(product)
  end

  test "create_product/1 given a product with the same name should throw an error message" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    assert {:ok, %Product{} = _product} = Products.create_product(input)
    assert {:error, changeset} = Products.create_product(input)
    assert "has already been taken" in errors_on(changeset).name
    assert %{name: ["has already been taken"]} = errors_on(changeset)
  end

  test "create_product/1 with an image and get the image_url" do
    file_upload = %Plug.Upload{
      content_type: "image/png",
      filename: "photo.png",
      path: "test/support/fixtures/photo.png"
    }

    input = %{
      name: "Pizza",
      size: "small",
      price: 100,
      description: "Massa italiana",
      product_url: file_upload
    }

    assert {:ok, product} = Products.create_product(input)
    url = Products.get_image(product)
    assert String.contains?(url, file_upload.filename)
  end

  test "create_product/1 with invalid image type" do
    file_upload = %Plug.Upload{
      content_type: "image/svg",
      filename: "photo .svg",
      path: "test/support/fixtures/photo.svg"
    }

    input = %{
      name: "Pizza",
      size: "small",
      price: 100,
      description: "Massa italiana",
      product_url: file_upload
    }

    assert {:error, changeset} = Products.create_product(input)
    assert "file type is invalid" in errors_on(changeset).product_url
  end

  test "update_product/1" do
    input = %{name: "Pizza", size: "small", price: 100, description: "Massa italiana"}

    {:ok, product} = Products.create_product(input)
    {:ok, %Product{} = product} = Products.update_product(product, %{name: "abobora"})

    assert product.name == "abobora"
  end
end
