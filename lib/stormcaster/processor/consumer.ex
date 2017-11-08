defmodule Stormcaster.Processor.Consumer do
  use GenStage
  require Logger
  alias Stormcaster.Repo
  alias Stormcaster.Replay
  alias Stormcaster.ReplayPlayer
  alias Stormcaster.ReplayTimeline
  alias Stormcaster.ReplayFile

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [Stormcaster.Processor.Producer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      process_replay(event)
    end

    {:noreply, [], state}
  end

  defp process_replay(uuid) do
    replay = Replay.by_signature(uuid)
    replay_url = ReplayFile.url({"replay.StormReplay", uuid})

    case Stormcaster.Parser.parse_replay(replay_url) do
      {:error, e} ->
        changeset = Replay.changeset(replay, %{processed_at: NaiveDateTime.utc_now, result: "error"})
        Repo.update(changeset)
        IO.inspect e
      {:ok, replay_data} -> extract_replay_details(replay, replay_data)
    end
  end

  defp extract_replay_details(replay, replay_data) do
    #result = Repo.transaction(fn ->
       extract_players_from_replay(replay, replay_data)
       extract_timeline_from_replay(replay, replay_data)
       #end)
       #IO.inspect result
  end

  defp extract_players_from_replay(replay, replay_data) do
    for player <- replay_data["players"] do
      IO.inspect "got player with name '#{player["name"]}'"

      updated_attrs = %{
        "replay_id" => replay.id,
        "hero" => player["character"],
        "hero_level" => player["character_level"],
        "slot_id" => player["index"],
        "team_id" => player["team"],
        "battletag" => player["name"]
      }

      player = Map.merge(player, updated_attrs)
      changeset = ReplayPlayer.changeset(%ReplayPlayer{}, player)
      IO.inspect Repo.insert(changeset)
    end
  end

  defp extract_timeline_from_replay(replay, replay_data) do
    # Create an implicit game_start event.
    event = %{"replay_id" => replay.id, "event_type" => "game_start", "event_time" => 0}
    changeset = ReplayTimeline.changeset(%ReplayTimeline{}, event)
    IO.inspect Repo.insert(changeset)
  end
end
