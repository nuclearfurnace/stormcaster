defmodule Stormcaster.Processor do
  def process(uuid) do
    GenStage.cast(Stormcaster.Processor.Producer, {:process, uuid})
  end
end
