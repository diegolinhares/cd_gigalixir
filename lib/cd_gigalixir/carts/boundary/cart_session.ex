defmodule CdGigalixir.Carts.Boundary.CartSession do
  use GenServer

  alias CdGigalixir.Carts.Core.HandleCarts, as: Cart

  def start_link(_) do
    GenServer.start_link(__MODULE__, :cart_session, name: :cart_session)
  end

  def init(name) do
    :ets.new(name, [:set, :public, :named_table])
    {:ok, name}
  end

  def handle_cast({:create, cart_id}, name) do
    case find_cart(name, cart_id) do
      {:not_found, []} -> :ets.insert(name, {cart_id, Cart.create_cart(cart_id)})
      {:ok, _value} -> :return_cache
    end

    {:noreply, name}
  end

  def handle_cast({:add, cart_id, product}, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = Cart.add(cart, product)

    :ets.insert(name, {cart_id, cart})

    {:noreply, name}
  end

  def handle_cast({:delete_cart, cart_id}, name) do
    :ets.delete(name, cart_id)

    {:noreply, name}
  end

  def handle_call({:inc, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = Cart.inc(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  def handle_call({:dec, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = Cart.dec(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  def handle_call({:remove, cart_id, product_id}, _from, name) do
    {:ok, cart} = find_cart(name, cart_id)
    cart = Cart.remove(cart, product_id)

    :ets.insert(name, {cart_id, cart})

    {:reply, cart, name}
  end

  def handle_call({:get, cart_id}, _from, name) do
    case find_cart(name, cart_id) do
      {:ok, cart} ->
        {:reply, cart, name}

      {:not_found, []} ->
        {:reply, [], name}
    end
  end

  defp find_cart(name, cart_id) do
    case :ets.lookup(name, cart_id) do
      [] -> {:not_found, []}
      [{_cart_id, cart}] -> {:ok, cart}
    end
  end
end
