defmodule AsicSentry.Worker.ExpectedStatusFetcher do
  use GenServer
  require Logger
  alias AsicSentry.Configs
  alias AsicSentry.AsicMiners.AsicMiner
  alias AsicSentry.AsicMiners

  @single_api_path "/asic_miners/expected_status"
  @bulk_api_path   "/asic_miners/expected_status_bulk"

  def start_link(_), do: start_link()
  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    Logger.info("[AsicSentry.Worker.ExpectedStatusFetcher] Started")
    {:ok, pid}
  end

  @impl true
  def init(_) do
    Process.send_after(__MODULE__, :execute_loop, 5_000)
    {:ok, nil}
  end

  @impl true
  def handle_info(:execute_loop, _state) do
    Logger.info("[AsicSentry.Worker.ExpectedStatusFetcher] execute_loop")
    execute()
    Process.send_after(__MODULE__, :execute_loop, 5_000)
    {:noreply, nil}
  end

  def execute() do
    Logger.info("[AsicSentry.Worker.ExpectedStatusFetcher] Execute")
    asic_miner_list = AsicSentry.AsicMiners.list_asic_miners()
    cond do
      Kernel.length(asic_miner_list) == 0 ->
        Logger.info(:info, "[ExpectedStatusFetcher] No ASIC Miner found.")
      Kernel.length(asic_miner_list) == 1 ->
        [asic_miner] = asic_miner_list
        execute_case_single(%AsicMiner{}=asic_miner)
      Kernel.length(asic_miner_list) > 1 ->
        execute_case_bulk(asic_miner_list)
    end
  end

  def execute_case_single(%AsicMiner{}=asic_miner) do
    with {:ok, api_url} <- get_single_api_url(),
         {:ok, asic_miner_params} <- fetch_expected_status_single(api_url, asic_miner.api_code) do
      {:ok, asic_miner_updated} = AsicMiners.update_asic_miner_by_commander(asic_miner, asic_miner_params)
      Phoenix.PubSub.broadcast(AsicSentry.PubSub, "asic_miner_index_channel", {:asic_miner_index_channel, :create_or_update, asic_miner_updated})
    end
  end

  def execute_case_bulk(asic_miner_list) do
    api_code_list = Enum.map(asic_miner_list, &(&1.api_code))
    with {:ok, api_url} <- get_bulk_api_url(),
         {:ok, asic_miner_params_map} <- fetch_expected_status_bulk(api_url, api_code_list) do
      api_code_key_list = Map.keys(asic_miner_params_map)
      for key <- api_code_key_list do
        asic_miner_params = Map.get(asic_miner_params_map, key)
        asic_miner = AsicMiners.get_asic_miner_by_api_code!(key)
        {:ok, asic_miner_updated} = AsicMiners.update_asic_miner_by_commander(asic_miner, asic_miner_params)
        Phoenix.PubSub.broadcast(AsicSentry.PubSub, "asic_miner_index_channel", {:asic_miner_index_channel, :create_or_update, asic_miner_updated})
      end
    end
  end

  def fetch_expected_status_single(api_single_url, api_code) when is_binary(api_code) do
    header_list = [
      {"api_code", api_code},
      {"Accept-Encoding", "application/json"}
    ]
    case HTTPoison.get(api_single_url, header_list) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body_map = Jason.decode!(body)
        {:ok, body_map}
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        Logger.info("[ExpectedStatusFetcher] fetch_expected_status_single/2 invalid API_CODE")
        {:error, :invalid_api_code}
      {:error, %HTTPoison.Error{}} ->
        Logger.info("[ExpectedStatusFetcher] fetch_expected_status_single/2 HTTP ERROR")
        {:error, :http_poison_error}
    end
  end

  def fetch_expected_status_bulk(api_bulk_url, api_code_list) when is_list(api_code_list) do
    header_list = [
      {"Content-Type",    "application/json"},
      {"Accept-Encoding", "application/json"}
    ]
    body = %{
      "api_code_list" => api_code_list
    } |> Jason.encode!()

    case HTTPoison.post(api_bulk_url, body, header_list) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body_map = Jason.decode!(body)
        {:ok, body_map}
      {:error, %HTTPoison.Error{}} ->
        Logger.info("[ExpectedStatusFetcher] fetch_expected_status_bulk/2 HTTP ERROR")
        {:error, :http_poison_error}
    end
  end

  def get_single_api_url() do
    case Configs.get_mining_rig_commander_api_url() do
      {:error, :config_not_found} -> {:error, :config_not_found}
      {:ok, mining_rig_commander_api_url} ->
        api = Path.join([mining_rig_commander_api_url, @single_api_path])
        {:ok, api}
    end
  end

  def get_bulk_api_url() do
    case Configs.get_mining_rig_commander_api_url() do
      {:error, :config_not_found} -> {:error, :config_not_found}
      {:ok, mining_rig_commander_api_url} ->
        api = Path.join([mining_rig_commander_api_url, @bulk_api_path])
        {:ok, api}
    end
  end
end
