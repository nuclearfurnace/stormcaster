defmodule Stormcaster.Replay do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Stormcaster.Repo
  alias Stormcaster.Replay


  schema "replays" do
    field :signature, :string
    field :location, :string
    field :processed_at, :naive_datetime
    field :result, :string

    timestamps()
  end

  def by_replay_id(replay_id) do
    Replay |> where(id: ^replay_id) |> Repo.fetch_one
  end

  def by_signature(uuid) do
    Replay |> where(signature: ^uuid) |> Repo.fetch_one
  end

  @doc false
  def changeset(%Replay{} = replay, attrs) do
    replay
    |> cast(attrs, [:signature, :location, :processed_at, :result])
    |> unique_constraint(:signature)
    |> validate_required([:signature, :location])
  end
end
