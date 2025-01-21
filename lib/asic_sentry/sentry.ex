defmodule AsicSentry.Sentry do
  use GenServer
  require Logger

  alias AsicSentry.Configs
  alias AsicSentry.AsicMiners.AsicMiner

  @asic_miner_model_and_module_map %{
    "Ice River - KS5L" => AsicSentry.Miners.IceRiverKS5L
  }

  @impl true
  def init(_params) do
    {:ok, nil}
  end

  def start_link(_args), do: start_link()
  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    Logger.info("[#{__MODULE__}] collect and send operational data for all asic miners after 5 seconds")
    Process.send_after(__MODULE__, :collect_and_send_operational_data_for_all_asic_miners, 5_000)
    {:ok, pid}
  end

  def handle_info(:collect_and_send_operational_data_for_all_asic_miners, state) do
    collect_and_send_operational_data_for_all_asic_miners()
    Logger.info("[#{__MODULE__}] collect and send operational data for all asic miners after 10 seconds")
    Process.send_after(__MODULE__, :collect_and_send_operational_data_for_all_asic_miners, 10_000)
    {:noreply, state}
  end

  def collect_and_send_operational_data_for_all_asic_miners() do
    asic_miner_list = AsicSentry.AsicMiners.list_asic_miners()
    with {:ok, commander_api_url} <- get_mining_rig_commander_api_url() do
      for asic_miner <- asic_miner_list do
        collect_and_send_operational_data(asic_miner, commander_api_url)
      end
    else
      {:error, :config_not_found} ->
        Logger.error("[#{__MODULE__}] Cannot find config for mininig_rig_commander_api_url.")
      other_error -> other_error
    end
  end

  def collect_and_send_operational_data(%AsicMiner{} = asic_miner, mining_rig_commander_api_url) do
    with {:ok, asic_miner_module} <-  get_asic_miner_module(asic_miner.asic_model),
         {:ok, response_body} <- asic_miner_module.fetch_asic_operational_data(asic_miner.ip),
         {:ok, response_body_map} <- asic_miner_module.convert_response_body_to_map(response_body),
           composed_data <- asic_miner_module.compose_asic_operational_data(response_body_map),
         {:ok, %Tesla.Env{}=result} <-asic_miner_module.submit_asic_operational_data(mining_rig_commander_api_url, asic_miner.api_code, composed_data)
      do
        Logger.info("[#{asic_miner_module}][ASIC Miner: ##{asic_miner.id}] Collect and send operational data successfully.")
      else
        {:error, :fetch_asic_operational_data, full_api_url} ->
          Logger.error("[ASIC Miner: ##{asic_miner.id}] Cannot fetch asic operational data from #{full_api_url}.")
        {:error, :convert_to_map} ->
          Logger.error("[ASIC Miner: ##{asic_miner.id}] Cannot convert response's body from string to map %{}.")
        {:error, :invalid_api_code, api_code} ->
          Logger.error("[ASIC Miner: ##{asic_miner.id}] Invalid API_CODE  #{api_code}")
        {:error, :submit_asic_operational_data, full_api_url} ->
          Logger.error("[ASIC Miner: ##{asic_miner.id}] Cannot submit to #{full_api_url}")
        other_error -> other_error
    end
  end

  def get_mining_rig_commander_api_url() do
    config = Configs.get_config_by_key("mininig_rig_commander_api_url")
    if Kernel.is_nil(config) do
      {:error, :config_not_found}
    else
      {:ok, config.value}
    end
  end

  def get_asic_miner_module(asic_model) do
    asic_miner_module = Map.get(@asic_miner_model_and_module_map, asic_model, nil)
    if Kernel.is_nil(asic_miner_module) do
      {:error, :invalid_asic_model}
    else
      {:ok, asic_miner_module}
    end
  end
end
