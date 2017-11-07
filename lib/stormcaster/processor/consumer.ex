defmodule Stormcaster.Processor.Consumer do
  use GenStage
  require Logger
  alias Stormcaster.Repo
  alias Stormcaster.Replay
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
    replay = Replay.by_uuid(uuid)
    replay_url = ReplayFile.url({"replay", uuid})

    case Stormcaster.Parser.parse_replay(replay_url) do
      {:error, _} ->
        changeset = Replay.changeset(replay,
          %{processed_at: Ecto.DateTime.utc, result: "error"})
        case Repo.insert(changeset) do
          {:error, _} -> Logger.error "failed to mark replay as 'error' (#{uuid})"
        end
      {:ok, replay_data} -> extract_replay_details(replay, replay_data)
    end
  end

  defp extract_replay_details(replay, replay_data) do
     result = Repo.transaction(fn ->
       extract_players_from_replay(replay, replay_data)
       extract_timeline_from_replay(replay, replay_data)
     end)
  end

  defp extract_players_from_replay(replay, replay_data) do
  end

  defp extract_timeline_from_replay(replay, replay_data) do
  end
end
