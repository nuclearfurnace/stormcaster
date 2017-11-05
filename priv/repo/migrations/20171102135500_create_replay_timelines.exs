defmodule Stormcaster.Repo.Migrations.CreateReplayTimelines do
  use Ecto.Migration

  def change do
    create table(:replay_timelines) do
      add :replay_id, :integer, primary_key: true
      add :event_time, :integer
      add :event_type, :string
      add :team_id, :integer
      add :event_details, :text

      timestamps()
    end

  end
end
