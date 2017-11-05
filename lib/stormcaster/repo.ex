defmodule Stormcaster.Repo do
  use Ecto.Repo, otp_app: :stormcaster

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def fetch(query) do
    case all(query) do
      [] -> {:error, :no_rows}
      xs -> {:ok, xs}
    end
  end

  def fetch_one(schema, clauses \\ []) do
    case get_by(schema, clauses, []) do
      nil -> {:error, nil}
      [x] -> {:ok, x}
    end
  end
end
