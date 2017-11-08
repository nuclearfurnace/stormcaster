defmodule StormcasterWeb.ReplayView do
  use StormcasterWeb, :view

  def render_replay_event(event) do
    _render_replay_event(event.event_type, event)
  end

  def _render_replay_event("game_start", _event) do
    render "block_game_start.html"
  end

  def _render_replay_event("camp_capture", event) do
    event_time = get_formatted_time(event.event_time)
    team_color = get_color_by_team(event.team_id)
    team_name = get_name_by_team(event.team_id)
    camp_type = get_event_detail(event, "camp_type")

    render "block_camp_capture.html",
      event_time: event_time,
      team_color: team_color,
      team_name: team_name,
      camp_type: camp_type
  end

  def get_formatted_time(time) do
    minutes = div time, 60
    seconds = rem time, 60
    seconds_pad = if seconds < 10 do "0" else "" end

    "#{minutes}:#{seconds_pad}#{seconds}"
  end

  def get_color_by_team(team_id) do
    case team_id do
      0 -> "alert-primary"
      1 -> "alert-danger"
      _ -> "alert-warning"
    end
  end

  def get_name_by_team(team_id) do
    case team_id do
      0 -> gettext "Blue team"
      1 -> gettext "Red team"
      _ -> gettext "Unknown team"
    end
  end

  def get_hero_image_path(player) do
    listed_name = player.hero |> String.downcase |> String.replace(~r/[^a-zA-Z]/, "")
    real_name = case listed_name do
      "sonya" -> "femalebarbarian"
      "liming" -> "wizard"
      name -> name
    end

    "/images/heroes/storm_ui_ingame_hero_leaderboard_#{real_name}.png"
  end

  def get_event_detail(event, key) do
    decoded = Poison.decode!(event.event_details)
    decoded[key]
  end
end
