defmodule StormcasterWeb.ReplayController do
  use StormcasterWeb, :controller
  alias Stormcaster.Repo
  alias Stormcaster.Replay
  alias Stormcaster.ReplayPlayer
  alias Stormcaster.ReplayTimeline
  alias Stormcaster.ReplayFile

  def show(conn, %{"id" => replay_id}) do
    with {:ok, replay} <- Replay.by_replay_id(replay_id),
         {:ok, players} <- ReplayPlayer.by_replay_id(replay_id),
         {:ok, timeline} <- ReplayTimeline.by_replay_id(replay_id) do
      render(conn, "show.html", replay: replay, players: players, timeline: timeline)
    else
      {:error, errmsg} -> render(conn, "error.html", error: errmsg)
    end
  end

  def create(conn, %{"replay" => replay}) do
    # We do a quick check here to see if we even think its a real replay
    # since we don't want to store it yet and bother to further process it
    # if we're pretty sure that it's fake.
    case get_basic_replay_validity(replay) do
      {:error, :not_valid} -> conn |> put_status(400) |> json(%{status: "error", errors: ["replay invalid"]})
      {:ok, uuid} ->
        case enqueue_replay_for_processing(replay, uuid) do
          {:ok, filename} -> conn |> json(%{status: "success", data: %{uuid: uuid, filename: filename}})
          {:error, e} -> conn |> put_status(500) |> json(%{status: "error", errors: ["failed to store replay", e]})
        end
    end
  end

  defp get_basic_replay_validity(%Plug.Upload{path: path}) do
    Stormcaster.Parser.validate_replay(path)
  end

  defp enqueue_replay_for_processing(replay, uuid) do
    # Gotta move the file to durable storage for processing.
    replay = %Plug.Upload{replay | filename: "replay.StormReplay"}
    case ReplayFile.store({replay, uuid}) do
      {:ok, stored} ->
        changeset = Replay.changeset(%Replay{}, %{signature: uuid, location: stored, result: "uploaded"})
        case Repo.insert(changeset) do
          {:ok, _} ->
            Stormcaster.Processor.process(uuid)
            {:ok, stored}
          {:error, changeset} ->
            case Keyword.get(changeset.errors, :signature) do
              {"has already been taken", _} -> {:error, "replay already exists"}
              _ -> {:error, "unknown database error while storing replay"}
            end
        end
      {:error, e} -> {:error, e}
    end
  end
end
