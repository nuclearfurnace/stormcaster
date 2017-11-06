defmodule Stormcaster.Repo.Migrations.CreateReplays do
  use Ecto.Migration

  def change do
    create table(:replays) do
      add :signature, :string
      add :location, :text
      add :processed_at, :naive_datetime, null: true
      add :result, :integer, default: -1

      timestamps()
    end

    create unique_index(:replays, :signature)
  end
end
