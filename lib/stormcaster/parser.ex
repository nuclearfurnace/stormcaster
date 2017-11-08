defmodule Stormcaster.Parser do
  def validate_replay(path) do
    storm_parser_bin = Application.get_env(:stormcaster, :storm_parser_bin)
    IO.inspect path
    abs_path = Path.absname(path)
    IO.inspect abs_path
    result = Porcelain.shell("#{storm_parser_bin} --validate #{abs_path}")
    case result.status do
      0 -> {:ok, result.out |> String.trim}
      _ -> {:error, :not_valid}
    end
  end

  def parse_replay(path) do
    storm_parser_bin = Application.get_env(:stormcaster, :storm_parser_bin)
    IO.inspect path
    abs_path = Path.absname(path)
    IO.inspect abs_path
    result = Porcelain.shell("#{storm_parser_bin} #{abs_path}")
    case result.status do
      0 ->
        case Poison.decode(result.out) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "invalid json from storm-parser"}
        end
      _ -> {:error, result.out}
    end
  end
end
