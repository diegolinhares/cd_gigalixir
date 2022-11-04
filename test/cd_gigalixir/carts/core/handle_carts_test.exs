defmodule CdGigalixir.Carts.Core.HandleCartsTest do
  use CdGigalixir.DataCase
  import CdGigalixir.Factory
  alias CdGigalixir.Carts.Core.Data.Cart
  import CdGigalixir.Carts.Core.HandleCarts

  @start_cart %Cart{
    id: 444,
    items: [],
    total_qty: 0,
    total_price: %Money{amount: 0, currency: :BRL}
  }

  describe "handle carts" do
    test "should create a new cart" do
      assert @start_cart == create_cart(444)
    end

    test "should add a new item in the cart" do
      product = insert(:product)

      cart = add(@start_cart, product)

      assert 1 == cart.total_qty
      assert product.price == cart.total_price
      assert [%{item: product, qty: 1}] == cart.items
    end

    test "should add the same item twice" do
      product = insert(:product)

      cart =
        @start_cart
        |> add(product)
        |> add(product)

      assert 2 == cart.total_qty
      assert Money.add(product.price, product.price) == cart.total_price
      assert [%{item: product, qty: 2}] == cart.items
    end

    test "should remove a item" do
      product = insert(:product)
      product_2 = insert(:product)

      total_price = Money.add(product.price, product.price) |> Money.add(product_2.price)

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> add(product_2)

      assert 3 == cart.total_qty
      assert total_price == cart.total_price
      assert [%{item: product, qty: 2}, %{item: product_2, qty: 1}] == cart.items

      cart = remove(cart, product.id)
      assert 1 == cart.total_qty
      assert product_2.price == cart.total_price
      assert [%{item: product_2, qty: 1}] == cart.items
    end

    test "should increment the same element into the cart" do
      product = insert(:product)

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> inc(product.id)

      total_price = Money.add(product.price, product.price) |> Money.add(product.price)

      assert 3 == cart.total_qty
      assert total_price == cart.total_price
    end

    test "should decrement the same element into the cart" do
      product = insert(:product)

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> dec(product.id)

      total_price = Money.add(product.price, product.price) |> Money.subtract(product.price)

      assert 1 == cart.total_qty
      assert total_price == cart.total_price
    end

    test "should decrement until remove the product" do
      product = insert(:product)

      cart =
        @start_cart
        |> add(product)
        |> add(product)
        |> dec(product.id)
        |> dec(product.id)

      assert [] == cart.items
      assert 0 == cart.total_qty
      assert Money.new(0) == cart.total_price
    end

    test "should add two different items in the same cart" do
      product = insert(:product)
      product_2 = insert(:product)

      cart =
        @start_cart
        |> add(product)
        |> add(product_2)

      total_price = Money.add(product.price, product_2.price)

      assert 2 == cart.total_qty
      assert total_price == cart.total_price
    end
  end
end
