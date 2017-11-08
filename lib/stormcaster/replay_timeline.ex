defmodule Stormcaster.ReplayTimeline do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  import StormcasterWeb.Gettext
  alias Stormcaster.Repo
  alias Stormcaster.ReplayTimeline


  schema "replay_timelines" do
    field :event_details, :string
    field :event_time, :integer
    field :event_type, :string
    field :replay_id, :integer
    field :team_id, :integer

    timestamps()
  end

  def by_replay_id(replay_id) do
    ReplayTimeline |> where(replay_id: ^replay_id) |> order_by([r], asc: r.event_time) |> Repo.fetch
  end

  @doc false
  def changeset(%ReplayTimeline{} = replay_timeline, attrs) do
    replay_timeline
    |> cast(attrs, [:replay_id, :event_time, :event_type, :team_id, :event_details])
    |> validate_required([:replay_id, :event_time, :event_type])
  end
end
