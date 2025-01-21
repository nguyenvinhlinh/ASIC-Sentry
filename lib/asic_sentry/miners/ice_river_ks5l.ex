defmodule AsicSentry.Miners.IceRiverKS5L do
  require Logger
  @behaviour AsicSentry.Miners.GeneralMiner

  @impl true
  def fetch_asic_operational_data(ip) do
    full_api_url = "http://#{ip}/user/userpanel"
    data_raw = "post=4"
    header_list = [
      {"content-type", "application/x-www-form-urlencoded; charset=UTF-8"}
    ]
    case Tesla.post(full_api_url, data_raw, headers: header_list) do
      {:ok, response} -> {:ok, response.body}
      {:error, _response} ->
        {:error, :fetch_asic_operational_data, full_api_url}
    end
  end

  @impl true
  def fetch_asic_specs(ip) do
    fetch_asic_operational_data(ip)
  end

  @impl true
  def convert_response_body_to_map(body_response) do
    case Jason.decode(body_response) do
      {:ok, body_response_map} -> {:ok, body_response_map}
      {:error, _} -> {:error, :convert_to_map}
    end
  end

  @impl true
  def compose_asic_operational_data(body_response_map) do
    [hashrate_5_min, hashrate_30_min] =  get_hashrate_list(body_response_map)
    pool_rejection_rate = get_pool_rejection_rate(body_response_map)
    runtime = get_runtime(body_response_map)

    [pool_1_address, pool_2_address, pool_3_address] = get_pools_address_list(body_response_map)
    [pool_1_user,    pool_2_user,    pool_3_user] =    get_pools_user_list(body_response_map)
    [pool_1_state,   pool_2_state,   pool_3_state] =   get_pools_state_list(body_response_map)

    [pool_1_accepted_share, pool_2_accepted_share, pool_3_accepted_share] = get_pools_accepted_share_list(body_response_map)
    [pool_1_rejected_share, pool_2_rejected_share, pool_3_rejected_share] = get_pools_rejected_share_list(body_response_map)

    [hashboard_1_hashrate_5_min, hashboard_2_hashrate_5_min, hashboard_3_hashrate_5_min] = get_hashboard_5m_list(body_response_map)
    [hashboard_1_hashrate_30_min, hashboard_2_hashrate_30_min, hashboard_3_hashrate_30_min] = get_hashboard_30m_list(body_response_map)
    [hashboard_1_temp_1, hashboard_1_temp_2,
     hashboard_2_temp_1, hashboard_2_temp_2,
     hashboard_3_temp_1, hashboard_3_temp_2] = get_hashboard_temp_list(body_response_map)

    [fan_1_speed, fan_2_speed, fan_3_speed, fan_4_speed] = get_fan_speed_list(body_response_map)

    lan_ip = get_ip(body_response_map)

    %{
      "hashrate_5_min" => hashrate_5_min,
      "hashrate_30_min" => hashrate_30_min,
      "hashrate_uom" => "GH/s", # this is default value
      "pool_rejection_rate" => pool_rejection_rate,
      "uptime" => runtime,
      "pool_1_address" => pool_1_address,
      "pool_2_address" => pool_2_address,
      "pool_3_address" => pool_3_address,
      "pool_1_user" => pool_1_user,
      "pool_2_user" => pool_2_user,
      "pool_3_user" => pool_3_user,
      "pool_1_state" => pool_1_state,
      "pool_2_state" => pool_2_state,
      "pool_3_state" => pool_3_state,
      "pool_1_accepted_share" => pool_1_accepted_share,
      "pool_2_accepted_share" => pool_2_accepted_share,
      "pool_3_accepted_share" => pool_3_accepted_share,
      "pool_1_rejected_share" => pool_1_rejected_share,
      "pool_2_rejected_share" => pool_2_rejected_share,
      "pool_3_rejected_share" => pool_3_rejected_share,
      "hashboard_1_hashrate_5_min" =>  hashboard_1_hashrate_5_min,
      "hashboard_2_hashrate_5_min" =>  hashboard_2_hashrate_5_min,
      "hashboard_3_hashrate_5_min" =>  hashboard_3_hashrate_5_min,
      "hashboard_1_hashrate_30_min" => hashboard_1_hashrate_30_min,
      "hashboard_2_hashrate_30_min" => hashboard_2_hashrate_30_min,
      "hashboard_3_hashrate_30_min" => hashboard_3_hashrate_30_min,
      "hashboard_1_temp_1" => hashboard_1_temp_1,
      "hashboard_1_temp_2" => hashboard_1_temp_2,
      "hashboard_2_temp_1" => hashboard_2_temp_1,
      "hashboard_2_temp_2" => hashboard_2_temp_2,
      "hashboard_3_temp_1" => hashboard_3_temp_1,
      "hashboard_3_temp_2" => hashboard_3_temp_2,
      "fan_1_speed" => fan_1_speed,
      "fan_2_speed" => fan_2_speed,
      "fan_3_speed" => fan_3_speed,
      "fan_4_speed" => fan_4_speed,
      "lan_ip" => lan_ip,
      "wan_ip" => nil,        # this is default value
      "coin_name" => "Kaspa", # this is default value
      "power" => 3500         # this is default value, override it if minining other coin.
    }
  end

  @impl true
  def submit_asic_operational_data(commander_api_url, api_code, data) do
    full_api_url = "#{commander_api_url}/asic_miners/logs"
    header_list = [
      {"content-type", "application/json"},
      {"api_code", api_code}
    ]

    case Tesla.post(full_api_url, Jason.encode!(data), [headers: header_list]) do
      {:ok, %Tesla.Env{status: 200}=result } -> {:ok, result}
      {:ok, %Tesla.Env{status: 401}} -> {:error, :invalid_api_code, api_code}
      {:ok, %Tesla.Env{body: body}} ->
        Logger.error(body)
        {:error, :submit_asic_operational_data, full_api_url}
      {:error, error} ->
        Logger.error(error)
        {:error, :submit_asic_operational_data, full_api_url}
    end
  end

  @impl true
  def submit_asic_specs(commander_api_url, api_code, data) do
    full_api_url = "#{commander_api_url}/asic_miners/specs"
    header_list = [
      {"content-type", "application/json"},
      {"api_code", api_code}
    ]
    case Tesla.post(full_api_url, Jason.encode!(data), [headers: header_list]) do
      {:ok, %Tesla.Env{status: 200}=result } -> {:ok, result}
      {:ok, %Tesla.Env{status: 401}} -> {:error, :invalid_api_code, api_code}
      {:ok, %Tesla.Env{body: body}} ->
        Logger.error(body)
        {:error, :submit_asic_specs, full_api_url}
      {:error, error} ->
        Logger.error(error)
        {:error, :submit_asic_specs, full_api_url}
    end
  end

  @impl true
  def compose_asic_specs(response_body_map) do
    %{
      "model" => "Ice River KS5L",
      "model_variant" => "unknown",
      "firmware_version" => get_firmware_version(response_body_map),
      "software_version" => get_software_version(response_body_map)
    }
  end

  def get_firmware_version(response_body_map) do
    firm_type = response_body_map
    |> Map.get("data")
    |> Map.get("firmtype")

    firm_ver_1 = response_body_map
    |> Map.get("data")
    |> Map.get("firmver1")

    firm_ver_2 = response_body_map
    |> Map.get("data")
    |> Map.get("firmver2")

    "#{firm_type} #{firm_ver_1} #{firm_ver_2}"
  end

  def get_software_version(response_body_map) do
    soft_ver_1 = response_body_map
    |> Map.get("data")
    |> Map.get("softver1")

    soft_ver_2 = response_body_map
    |> Map.get("data")
    |> Map.get("softver2")

    "#{soft_ver_1} #{soft_ver_2}"
  end

  def get_pool_rejection_rate(body_response_map) do
    body_response_map
    |> Map.get("data")
    |> Map.get("reject")
  end

  def get_runtime(body_response_map) do
    body_response_map
    |> Map.get("data", "runtime")
    |> Map.get("runtime")
  end

  def get_hashrate_list(body_response_map) do
    hashrate_5_min =  body_response_map
    |> Map.get("data")
    |> Map.get("rtpow")
    |> String.replace("G", "")
    |> String.to_integer()
    hashrate_30_min = body_response_map
    |> Map.get("data")
    |> Map.get("avgpow")
    |> String.replace("G", "")
    |> String.to_integer()
    [hashrate_5_min, hashrate_30_min]
  end

  def get_pools_address_list(body_response_map) do
    Enum.reduce([0, 1, 2], [], fn(index, acc) ->
      pool_address = body_response_map
      |> Map.get("data")
      |> Map.get("pools")
      |> Enum.at(index)
      |> Map.get("addr")
      acc ++ [pool_address]
    end)
  end

  def get_pools_user_list(body_response_map) do
    Enum.reduce([0, 1, 2], [], fn(index, acc) ->
      user = body_response_map
      |> Map.get("data")
      |> Map.get("pools")
      |> Enum.at(index)
      |> Map.get("user")
      acc ++ [user]
    end)
  end

  def get_pools_state_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      pool_state = body_response_map
      |> Map.get("data")
      |> Map.get("pools")
      |> Enum.at(index)
      |> Map.get("connect")

      pool_state_string = if (pool_state > 0), do: "Connected", else: "Unconnected"
      acc ++ [pool_state_string]
    end)
  end

  def get_pools_accepted_share_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      share = body_response_map
      |> Map.get("data")
      |> Map.get("pools")
      |> Enum.at(index)
      |> Map.get("accepted")
      |> Kernel.round()

      acc ++ [share]
    end)
  end

  def get_pools_rejected_share_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      share = body_response_map
      |> Map.get("data")
      |> Map.get("pools")
      |> Enum.at(index)
      |> Map.get("rejected")
      |> Kernel.round()

      acc ++ [share]
    end)
  end

  def get_hashboard_5m_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      hashrate = body_response_map
      |> Map.get("data")
      |> Map.get("boards")
      |> Enum.at(index)
      |> Map.get("rtpow")
      |> String.replace("G", "")
      |> String.to_float()
      acc ++ [hashrate]
    end)
  end

  def get_hashboard_30m_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      hashrate = body_response_map
      |> Map.get("data")
      |> Map.get("boards")
      |> Enum.at(index)
      |> Map.get("avgpow")
      |> String.replace("G", "")
      |> String.to_float()
      acc ++ [hashrate]
    end)
  end

  def get_hashboard_temp_list(body_response_map) do
    Enum.reduce([0,1,2], [], fn(index, acc) ->
      temp_1 = body_response_map
      |> Map.get("data")
      |> Map.get("boards")
      |> Enum.at(index)
      |> Map.get("intmp")
      |> Kernel.round()

      temp_2 = body_response_map
      |> Map.get("data")
      |> Map.get("boards")
      |> Enum.at(index)
      |> Map.get("outtmp")
      |> Kernel.round()

      acc ++ [temp_1, temp_2]
    end)
  end

  def get_fan_speed_list(body_response_map) do
    body_response_map
    |> Map.get("data")
    |> Map.get("fans")
  end

  def get_ip(body_response_map) do
    body_response_map
    |> Map.get("data")
    |> Map.get("ip")
  end


  def test do
    asic_miner_ip = "192.168.1.10"
    api_code = "076afa02-d5ca-11ef-a6e1-ac1f6be80ad4"
    commander_api_url = "http://127.0.0.1:4000/api/v1"

    with {:ok, response_body} <- fetch_asic_operational_data(asic_miner_ip),
         {:ok, response_body_map} <- convert_response_body_to_map(response_body),
           composed_data <- compose_asic_operational_data(response_body_map),
         {:ok} <- submit_asic_operational_data(commander_api_url, api_code, composed_data)
      do

      :ok
      else
        {:error, :fetch_asic_operational_data} -> :ok
        {:error, :convert_to_map} -> :ok
        {:error, :submit_asic_operational_data} -> :ok
    end
  end
end
