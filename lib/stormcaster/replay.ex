defmodule Stormcaster.Replay do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stormcaster.Replay


  schema "replays" do
    field :signature, :string
    field :location, :string
    field :processed_at, :naive_datetime
    field :result, :integer

    timestamps()
  end

  @doc false
  def changeset(%Replay{} = replay, attrs) do
    replay
    |> cast(attrs, [:signature, :location, :processed_at, :result])
    |> unique_constraint(:signature)
    |> validate_required([:signature, :location])
  end
end
