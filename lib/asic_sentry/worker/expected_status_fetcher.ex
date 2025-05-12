defmodule AsicSentry.Worker.ExpectedStatusFetcher do
  use GenServer
  require Logger
  alias AsicSentry.Configs

  @single_api_path "/asic_miners/expected_status"
  @bulk_api_path   "/asic_miners/expected_status_bulk"

  @impl true
  def init(_) do
    {:ok, nil}
  end


  def execute() do
    asic_miner_list = AsicSentry.AsicMiners.list_asic_miners()

    cond do
      Kernel.length(asic_miner_list) == 0 ->
        Logger.info(:info, "[ExpectedStatusFetcher] No ASIC Miner found.")
        [asic_miner] = asic_miner_list



        nil
      Kernel.length(asic_miner_list) > 1 ->
        nil
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
        {:error, :invalid_api_code}
      {:error, %HTTPoison.Error{}} ->
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
        {:error, :http_poison_error}
    end
  end

  def get_single_api_url() do
    Logger.warning("[#{__MODULE__}] get_single_api_url/0 need unit test.")
    case Configs.get_mining_rig_commander_api_url() do
      {:error, :config_not_found} -> {:error, :config_not_found}
      {:ok, mining_rig_commander_api_url} ->
        api = Path.join([mining_rig_commander_api_url, @single_api_path])
        {:ok, api}
    end
  end

  def get_bulk_api_url() do
    Logger.warning("[#{__MODULE__}] get_bulk_api_url/0 need unit test.")
    case Configs.get_mining_rig_commander_api_url() do
      {:error, :config_not_found} -> {:error, :config_not_found}
      {:ok, mining_rig_commander_api_url} ->
        api = Path.join([mining_rig_commander_api_url, @bulk_api_path])
        {:ok, api}
    end
  end


  def test() do
    {:ok, mining_rig_commander_api_url} = Configs.get_mining_rig_commander_api_url()
    api_url = Path.join([mining_rig_commander_api_url, @single_api_path])
    api_code = "api_code_1"
    a = fetch_expected_status_single(api_url, api_code)

    IO.inspect "DEBUG #{__ENV__.file} @#{__ENV__.line}"
    IO.inspect a
    IO.inspect "END"
  end


end
