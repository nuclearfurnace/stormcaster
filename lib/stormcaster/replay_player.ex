defmodule Stormcaster.ReplayPlayer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Stormcaster.Repo
  alias Stormcaster.ReplayPlayer


  schema "replay_players" do
    field :battletag, :string
    field :hero, :string
    field :hero_level, :integer
    field :is_silenced, :boolean, default: false
    field :is_winner, :boolean, default: false
    field :name, :string
    field :replay_id, :integer
    field :slot_id, :integer
    field :team_id, :integer

    timestamps()
  end

  def by_replay_id(replay_id) do
    ReplayPlayer |> where(replay_id: ^replay_id) |> order_by([:team_id, :slot_id]) |> Repo.fetch
  end

  @doc false
  def changeset(%ReplayPlayer{} = replay_player, attrs) do
    replay_player
    |> cast(attrs, [:replay_id, :name, :battletag, :team_id, :slot_id, :is_winner, :is_silenced, :hero, :hero_level])
    |> validate_required([:replay_id, :name, :battletag, :team_id, :slot_id, :is_winner, :is_silenced, :hero, :hero_level])
  end
end
