defmodule Stormcaster.Parser do
  def do_validity_check(path) do
    storm_parser_bin = Application.get_env(:stormcaster, :storm_parser_bin)
    Porcelain.shell("#{storm_parser_bin} --validate #{path}")
  end
end
