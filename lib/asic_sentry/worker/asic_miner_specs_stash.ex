defmodule AsicSentry.Worker.AsicMinerSpecsStash do
  use GenServer
  require Logger

  def start_link(_args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    Logger.info("[#{__MODULE__}] Started")
    {:ok, pid}

  end
  def start_link(), do: start_link(nil)

  def get(asic_miner_id) when Kernel.is_integer(asic_miner_id) do
    GenServer.call(__MODULE__, {:get, asic_miner_id})
  end

  def put(asic_miner_id, specs) when Kernel.is_integer(asic_miner_id) do
    GenServer.cast(__MODULE__, {:put, asic_miner_id, specs})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:put, asic_miner_id, spec}, state) when Kernel.is_integer(asic_miner_id) do
    state_mod = Map.put(state, asic_miner_id, spec)
    {:noreply, state_mod}
  end

  @impl true
  def handle_call({:get, asic_miner_id}, _from,  state) when Kernel.is_integer(asic_miner_id) do
    specs = Map.get(state, asic_miner_id, %{})
    {:reply, specs, state}
  end
end
