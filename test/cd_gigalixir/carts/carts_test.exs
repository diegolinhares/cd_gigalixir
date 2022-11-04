defmodule CdGigalixir.CartsTest do
  use CdGigalixir.DataCase
  alias CdGigalixir.Carts
  import CdGigalixir.Factory

  test "should create session" do
    assert :ok == Carts.create(444)
  end

  test "should create session twice" do
    assert :ok == Carts.create(444)
    assert :ok == Carts.create(444)
  end

  test "should add a new product" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product = insert(:product)
    assert :ok = Carts.add(cart_id, product)
    assert 1 == Carts.get(cart_id).total_qty
  end

  test "should add the same item" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product = insert(:product)
    assert :ok = Carts.add(cart_id, product)
    assert 2 == Carts.inc(cart_id, product.id).total_qty
  end

  test "should increment products" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product_1 = insert(:product)
    product_2 = insert(:product)
    assert :ok = Carts.add(cart_id, product_1)
    assert :ok = Carts.add(cart_id, product_2)
    assert 3 == Carts.inc(cart_id, product_1.id).total_qty
  end

  test "should decrement the same item" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product = insert(:product)
    assert :ok = Carts.add(cart_id, product)
    assert 0 == Carts.dec(cart_id, product.id).total_qty
  end

  test "should decrement products" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product_1 = insert(:product)
    product_2 = insert(:product)
    assert :ok = Carts.add(cart_id, product_1)
    assert :ok = Carts.add(cart_id, product_2)
    assert 1 == Carts.dec(cart_id, product_1.id).total_qty
  end

  test "should remove product" do
    cart_id = Ecto.UUID.generate()
    assert :ok = Carts.create(cart_id)

    product = insert(:product)
    assert :ok = Carts.add(cart_id, product)
    assert :ok = Carts.add(cart_id, product)
    assert 2 == Carts.get(cart_id).total_qty
    assert 0 == Carts.remove(cart_id, product.id).total_qty
  end
end
