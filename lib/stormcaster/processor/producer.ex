defmodule Stormcaster.Processor.Producer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.DemandDispatcher}
  end

  def handle_cast({:process, uuid}, {queue, demand}) do
    queue = :queue.in(uuid, queue)
    {reversed_items, _state} = take_items(queue, demand, [])
    {:noreply, Enum.reverse(reversed_items), {queue, demand}}
  end

  def handle_demand(demand, {queue, pending_demand}) do
    {reversed_items, state} = take_items(queue, pending_demand + demand, [])
    {:noreply, Enum.reverse(reversed_items), state}
  end

  def take_items(queue, 0, items), do: {items, {queue, 0}}
  def take_items(queue, n, items) when n > 0 do
    case :queue.out(queue) do
      {:empty, ^queue} -> {items, {queue, n}}
      {{:value, item}, queue} -> take_items(queue, n - 1, [item | items])
    end
  end
end
