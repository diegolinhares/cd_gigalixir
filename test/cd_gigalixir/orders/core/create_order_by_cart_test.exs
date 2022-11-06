defmodule CdGigalixir.Orders.Core.CreateOrderByCartTest do
  use CdGigalixir.DataCase

  import CdGigalixir.AccountsFixtures
  import CdGigalixir.ProductFixtures

  alias CdGigalixir.Carts
  alias CdGigalixir.Oders.Core.CreateOrderByCart

  test "create order by cart with success" do
    product = product_fixture()
    user = user_fixture()

    assert :ok == Carts.create(user.id)
    assert :ok == Carts.add(user.id, product)
    assert 1 == Carts.get(user.id).total_qty

    payload = %{
      "address" => "123",
      "current_user" => user.id,
      "phone_number" => "22222"
    }

    {:ok, result} = CreateOrderByCart.execute(payload)
    assert 1 == result.total_quantity
    assert [] == Carts.get(user.id)
  end

  test "create order by cart with error" do
    user = user_fixture()

    assert :ok == Carts.create(user.id)

    payload = %{
      "address" => "123",
      "current_user" => user.id,
      "phone_number" => "22222"
    }

    {:error, changeset} = CreateOrderByCart.execute(payload)
    assert ["must be greater than 0"] == errors_on(changeset).total_quantity
  end
end
