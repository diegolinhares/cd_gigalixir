defmodule CdGigalixir.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:description, :string)

      timestamps()
    end
  end
end
