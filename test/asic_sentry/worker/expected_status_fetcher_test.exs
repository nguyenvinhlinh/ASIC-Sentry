defmodule AsicSentry.Worker.ExpectedStatusFetcherTest do
  use AsicSentry.DataCase
  alias AsicSentry.Worker.ExpectedStatusFetcher, as: Fetcher
  alias AsicSentry.AsicMinersFixtures

  describe "unit test group which need to call api to mining rig commander" do
    setup [:setup_single_api_url, :setup_bulk_api_url, :create_asic_miner_list]
    @tag integration_test: true
    test "fetch_expected_status_single with valid api_code",
      %{single_api_url: single_api_url, asic_miner_1: asic_miner_1} do
      {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_single(single_api_url, asic_miner_1.api_code)
      assert test_result_e1 == :ok
      assert Kernel.is_map(test_result_e2)
      assert Map.has_key?(test_result_e2, "asic_expected_status")
      assert Map.has_key?(test_result_e2, "light_expected_status")
    end

    @tag integration_test: true
    test "fetch_expected_status_single with invalid api_code",
      %{single_api_url: single_api_url} do
      {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_single(single_api_url, "invalid api code")
      assert test_result_e1 == :error
      assert test_result_e2 == :invalid_api_code
    end

    @tag integration_test: true
    test "fetch_expected_status_bulk with valid api_code_list",
      %{bulk_api_url: bulk_api_url, asic_miner_1: asic_miner_1, asic_miner_2: asic_miner_2} do
      api_code_list = [asic_miner_1.api_code, asic_miner_2.api_code]
      {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_bulk(bulk_api_url, api_code_list)
      assert test_result_e1 == :ok
      assert Map.has_key?(test_result_e2, asic_miner_1.api_code)
      assert Map.has_key?(test_result_e2, asic_miner_2.api_code)

      api_code_1_expected_status = Map.get(test_result_e2, asic_miner_1.api_code)
      assert Map.has_key?(api_code_1_expected_status, "asic_expected_status")
      assert Map.has_key?(api_code_1_expected_status, "light_expected_status")
      assert Map.get(api_code_1_expected_status, "asic_expected_status") in ["on", "off"]
      assert Map.get(api_code_1_expected_status, "light_expected_status") in ["on", "off"]
    end

    @tag integration_test: true
    test "fetch_expected_status_bulk with invalid api_code_list",
      %{bulk_api_url: bulk_api_url, asic_miner_2: asic_miner_2} do

      {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_bulk(bulk_api_url, ["invalid_api_code", asic_miner_2.api_code])
      assert test_result_e1 == :ok
      assert Map.has_key?(test_result_e2, asic_miner_2.api_code)
      refute Map.has_key?(test_result_e2, "invalid_api_code")

      api_code_2_expected_status = Map.get(test_result_e2, asic_miner_2.api_code)
      assert Map.has_key?(api_code_2_expected_status, "asic_expected_status")
      assert Map.has_key?(api_code_2_expected_status, "light_expected_status")
      assert Map.get(api_code_2_expected_status, "asic_expected_status") in ["on", "off"]
      assert Map.get(api_code_2_expected_status, "light_expected_status") in ["on", "off"]
    end
  end

  describe "function related to configs table" do
    setup [:create_config]

    test "get_single_api_url" do
      {test_result_e1, test_result_e2} = Fetcher.get_single_api_url()
      assert test_result_e1 == :ok
      assert test_result_e2 == "http://mining-rig-commander.xyz/api/v1/asic_miners/expected_status"
    end

    test "get_bulk_api_url" do
      {test_result_e1, test_result_e2} = Fetcher.get_bulk_api_url()
      assert test_result_e1 == :ok
      assert test_result_e2 == "http://mining-rig-commander.xyz/api/v1/asic_miners/expected_status_bulk"
    end
  end

  defp setup_single_api_url(_) do
    root_api_url = "http://127.0.0.1:4000/api/v1"
    single_api_url = Path.join([root_api_url, "/asic_miners/expected_status"])
    %{single_api_url: single_api_url}
  end

  defp setup_bulk_api_url(_) do
    root_api_url = "http://127.0.0.1:4000/api/v1"
    bulk_api_url = Path.join([root_api_url, "/asic_miners/expected_status_bulk"])
    %{bulk_api_url: bulk_api_url}
  end

  defp create_asic_miner_list(_) do
    asic_miner_1 = AsicMinersFixtures.asic_miner_fixture(%{api_code: "api_code_1"})
    asic_miner_2 = AsicMinersFixtures.asic_miner_fixture(%{api_code: "api_code_2"})
    %{asic_miner_1: asic_miner_1, asic_miner_2: asic_miner_2}
  end

  defp create_config(_) do
    config = AsicSentry.ConfigsFixtures.config_fixture()
    %{config: config}
  end
end
