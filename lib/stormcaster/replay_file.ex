defmodule Stormcaster.ReplayFile do
  use Arc.Definition

  @versions [:original]

  def filename(version, {file, scope}) do
    "#{scope}.StormReplay"
  end
end
