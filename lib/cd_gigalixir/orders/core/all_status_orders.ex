defmodule CdGigalixir.Orders.Core.AllStatusOrders do
  import Ecto.Query

  alias CdGigalixir.Orders.Data.Order
  alias CdGigalixir.Repo

  defstruct all: 0,
            delivered: 0,
            delivering: 0,
            not_started: 0,
            preparing: 0,
            received: 0

  def execute do
    %__MODULE__{}
    |> count_all
    |> not_started
    |> delivered
    |> delivering
    |> not_started
    |> received
  end

  defp count_all(struct) do
    result =
      Order
      |> select([o], count(o.id))
      |> Repo.one()

    %{struct | all: result}
  end

  defp delivered(struct) do
    %{struct | delivered: filter_status(:DELIVERED)}
  end

  defp not_started(struct) do
    %{struct | not_started: filter_status(:NOT_STARTED)}
  end

  defp received(struct) do
    %{struct | received: filter_status(:RECEIVED)}
  end

  defp preparing(struct) do
    %{struct | preparing: filter_status(:PREPARING)}
  end

  defp delivering(struct) do
    %{struct | delivering: filter_status(:DELIVERING)}
  end

  defp filter_status(status) do
    Order
    |> where([o], o.status == ^status)
    |> select([o], count(o.id))
    |> Repo.one()
  end
end
