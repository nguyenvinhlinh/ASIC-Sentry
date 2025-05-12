defmodule AsicSentry.Worker.AsicMinerExpectedStatusFetcher do
  use GenServer
  require Logger
  alias AsicSentry.Configs

  @single_api_path "/asic_miners/expected_status"
  @bulk_api_path "/asic_miners/expected_status_many"

  @impl true
  def init(_) do
    {:ok, nil}
  end


  def looop do
    # get a list of all asic miner that need to get expected status
    # if the asic miner greater than 1, use bulk, else single api
    #
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

  def fetch_expected_status_many(api_many_url, api_code_list) when is_list(api_code_list) do
    Logger.warning("[#{__MODULE__}] fetch_expected_status/1 need unit test")
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
