defmodule StormcasterWeb.ReplayController do
  use StormcasterWeb, :controller
  alias Stormcaster.Repo
  alias Stormcaster.ReplayTimeline

  def show(conn, %{"id" => replay_id}) do
    with {:ok, replay_timeline} <- ReplayTimeline.get_timeline(replay_id) do
      render(conn, "show.html", timeline: replay_timeline)
    else
      {:error, errmsg} -> render(conn, "error.html", error: errmsg)
    end
  end
end
