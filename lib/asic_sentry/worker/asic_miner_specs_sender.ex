defmodule AsicSentry.Worker.AsicMinerSpecsSender do
  use GenServer
  require Logger
  import AsicSentry.Utils.CustomLogger, only: [log_and_broadcast: 2]

  alias AsicSentry.AsicMiners.AsicMiner
  alias AsicSentry.Configs
  alias AsicSentry.Worker.AsicMinerSpecsStash

  @impl true
  def init(_args), do: {:ok, %{}}

  def start_link(_args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    Logger.info("[#{__MODULE__}] Started")
    Process.send_after(__MODULE__, :collect_and_send_specs_for_all_asic_miners, 5_000)
    {:ok, pid}
  end
  def start_link(), do: start_link(nil)

  @impl true
  def handle_info(:collect_and_send_specs_for_all_asic_miners, state) do
    collect_and_send_specs_for_all_asic_miners()
    Process.send_after(__MODULE__, :collect_and_send_specs_for_all_asic_miners, 60_000)
    {:noreply, state}
  end

  def collect_and_send_specs_for_all_asic_miners() do
    asic_miner_list = AsicSentry.AsicMiners.list_asic_miners()
    with {:ok, commander_api_url} <- Configs.get_mining_rig_commander_api_url() do
      for asic_miner <- asic_miner_list do
        collect_and_send_specs(asic_miner, commander_api_url)
      end
    else
      {:error, :config_not_found} ->
        message = "[#{__MODULE__}] Cannot find config for mininig_rig_commander_api_url."
        log_and_broadcast(:error, message)
      other_error -> other_error
    end
  end

  def collect_and_send_specs(%AsicMiner{}=asic_miner, mining_rig_commander_api_url) do
    with {:ok, asic_miner_module} <- AsicMiner.get_asic_miner_module(asic_miner.asic_model),
         {:ok, response_body} <- asic_miner_module.fetch_asic_specs(asic_miner.ip),
         {:ok, response_body_map} <- asic_miner_module.convert_response_body_to_map(response_body),
           composed_data <- asic_miner_module.compose_asic_specs(response_body_map),
         {:ok} <- is_composed_data_duplicated?(asic_miner.id, composed_data),
         {:ok, %Tesla.Env{}} <- asic_miner_module.submit_asic_specs(mining_rig_commander_api_url, asic_miner.api_code, composed_data) do

      AsicMinerSpecsStash.put(asic_miner.id, composed_data)
      log_and_broadcast(:info, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Collect and send specs successfully.")
    else
      {:error, :fetch_asic_operational_data, full_api_url} ->
        log_and_broadcast(:error, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Cannot fetch asic operational data from #{full_api_url}.")

      {:error, :convert_to_map} ->
        log_and_broadcast(:error, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Cannot convert response's body from string to map %{}.")

      {:error, :duplicated_composed_data} ->
        log_and_broadcast(:info, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Specs has no changes. Skip submitting!")

      {:error, :invalid_api_code, api_code} ->
        log_and_broadcast(:error, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Invalid API_CODE  #{api_code}")

      {:error, :submit_asic_specs, full_api_url} ->
        log_and_broadcast(:error, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] Cannot submit to #{full_api_url}")

      other_error ->
        log_and_broadcast(:error, "[#{__MODULE__}][ASIC Miner: ##{asic_miner.id}] other_error #{other_error}")

    end
  end

  def is_composed_data_duplicated?(asic_miner_id, new_composed_data) do
    old_composed_data = AsicMinerSpecsStash.get(asic_miner_id)
    if Map.equal?(old_composed_data, new_composed_data) do
      {:error, :duplicated_composed_data}
    else
      {:ok}
    end
  end
end
