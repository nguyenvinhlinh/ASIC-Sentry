defmodule AsicSentry.Miners.GeneralMiner do
  @type asic_ip_address() :: String.t()
  @type response_body() :: String.t()
  @type response_body_map() :: Map.t()
  @type commander_api_url() :: String.t()
  @type api_code() :: String.t()
  @type asic_operational_data() :: Map.t()
  @type asic_specs() :: Map.t()

  @doc "Fetch ASIC operational data."
  @callback fetch_asic_operational_data(asic_ip_address())  :: {:ok, response_body()} | {:error, :fetch_asic_operational_data}

  @doc "Compose ASIC operational data to fit mining rig commander data payload."
  @callback compose_asic_operational_data(response_body_map()) :: asic_operational_data()

  @doc "Convert response body in string to map %{}"
  @callback convert_response_body_to_map(response_body()) :: {:ok, response_body_map()} | {:error, :convert_to_map}

  @doc "Submit ASIC operational data to mining rig commander"
  @callback submit_asic_operational_data(commander_api_url(), api_code(), asic_operational_data()) :: {:ok}


  @doc "Fetch ASIC specs from ASIC miner"
  @callback fetch_asic_specs(asic_ip_address()) :: {:ok, response_body()} | {:error, :fetch_asic_specs}

  @doc "Compose ASIC specs"
  @callback compose_asic_specs(response_body_map()) :: asic_specs()
  
  @doc "Submit ASIC specs to mining rig commander"
  @callback submit_asic_specs(commander_api_url(), api_code(), asic_specs()) :: {:ok}
end
