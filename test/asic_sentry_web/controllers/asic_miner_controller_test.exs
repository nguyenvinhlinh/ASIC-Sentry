defmodule AsicSentryWeb.AsicMinerControllerTest do
  use AsicSentryWeb.ConnCase
  alias AsicSentry.AsicMinersFixtures

  describe "valid rrc_serial_number" do
    setup [:create_asic_miner]
    test "get_expected_status with valid rrc_serial_number", %{conn: conn, asic_miner: asic_miner} do
      conn_mod = conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("rrc_serial_number", asic_miner.rrc_serial_number)

      test_result = get(conn_mod, "/api/v1/asic_miners/expected_status")
      assert test_result.status == 200

      test_result_body = Jason.decode!(test_result.resp_body)
      assert test_result_body
      expected_result_body = %{
        "name" => "Thanh Long",
        "asic_expected_status" => "on",
        "light_expected_status" => "off"
      }
      assert test_result_body == expected_result_body
    end
  end

  test "get_expected_status with no rrc_serial_number", %{conn: conn} do
    conn_mod = conn
    |> put_req_header("content-type", "application/json")

    test_result = get(conn_mod, "/api/v1/asic_miners/expected_status")
    assert test_result.status == 401
  end

  test "get_expected_status with invalid rrc_serial_number", %{conn: conn} do
    conn_mod = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("rrc_serial_number", "invalid rrc serial number")

    test_result = get(conn_mod, "/api/v1/asic_miners/expected_status")
    assert test_result.status == 401
  end

  defp create_asic_miner(_) do
    asic_miner = AsicMinersFixtures.asic_miner_fixture()
    update_params = %{name: "Thanh Long", asic_expected_status: "on", light_expected_status: "off"}
    {:ok, asic_miner_mod} =  AsicSentry.AsicMiners.update_asic_miner_by_commander(asic_miner, update_params)

    %{asic_miner: asic_miner_mod}
  end
end
