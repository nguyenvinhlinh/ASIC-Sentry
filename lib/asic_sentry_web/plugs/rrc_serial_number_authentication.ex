defmodule AsicSentryWeb.PLugs.RrcSerialNumberAuthentication do
  @behaviour Plug
  import Plug.Conn
  alias AsicSentry.AsicMiners

  @header_name "rrc_serial_number"

  def init(_params), do: nil

  def call(conn, _params) do
    with {:ok, rrc_serial_number} <- get_rrc_serial_number(conn),
         {:ok, asic_miner} <- get_asic_miner(rrc_serial_number) do
      assign(conn, :asic_miner, asic_miner)
    else
      {:error, :rrc_serial_number_not_exist} ->
        handle_rrc_serial_number_not_exist(conn)
      {:error, :rrc_serial_number_invalid} ->
        handle_api_code_invalid(conn)
    end
  end

  def get_rrc_serial_number(conn) do
    rrc_serial_number = conn
    |> Plug.Conn.get_req_header(@header_name)
    |> List.first

    if Kernel.is_nil(rrc_serial_number) do
      {:error, :rrc_serial_number_not_exist }
    else
      {:ok, rrc_serial_number}
    end
  end

  def get_asic_miner(rrc_serial_number) do
    case AsicMiners.get_asic_miner_by_rrc_serial_number(rrc_serial_number) do
      nil -> {:error, :rrc_serial_number_invalid}
      asic_miner -> {:ok, asic_miner}
    end
  end

  def handle_rrc_serial_number_not_exist(conn) do
    body = %{
      "message" => "RRC_SERIAL_NUMBER does not exist in request header."
    }
    conn
    |> put_status(401)
    |> Phoenix.Controller.json(body)
    |> halt()
  end

  def handle_api_code_invalid(conn) do
    body = %{
      "message" => "RRC_SERIAL_NUMBER invalid."
    }
    conn
    |> put_status(401)
    |> Phoenix.Controller.json(body)
    |> halt()
  end
end
