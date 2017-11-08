defmodule Stormcaster.ReplayFile do
  use Arc.Definition

  @versions [:original]

  def storage_dir(_version, {_file, _scope}) do
    case Application.get_env(:stormcaster, :replay_storage_dir) do
      {app, path} ->
        app_root = Application.app_dir(app)
        Path.join(app_root, path)
      path -> path
    end
  end

  def filename(_version, {file, scope}) do
    IO.inspect scope
    "#{scope}/#{file.file_name}"
  end
end
