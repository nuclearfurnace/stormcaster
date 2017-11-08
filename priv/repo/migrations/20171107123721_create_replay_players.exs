defmodule Stormcaster.Repo.Migrations.CreateReplayPlayers do
  use Ecto.Migration

  def change do
    create table(:replay_players) do
      add :replay_id, :integer
      add :name, :string
      add :battletag, :string
      add :team_id, :integer
      add :slot_id, :integer
      add :is_winner, :boolean, default: false, null: false
      add :is_silenced, :boolean, default: false, null: false
      add :hero, :string
      add :hero_level, :integer

      timestamps()
    end

  end
end
