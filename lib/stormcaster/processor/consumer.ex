defmodule Stormcaster.Processor.Consumer do
  use GenStage

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

  defp process_replay(_uuid) do
  end
end
