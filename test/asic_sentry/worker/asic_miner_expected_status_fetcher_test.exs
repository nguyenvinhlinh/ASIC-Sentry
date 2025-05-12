defmodule AsicSentry.Worker.AsicMinerExpectedStatusFetcherTest do
  use ExUnit.Case
  alias AsicSentry.Worker.AsicMinerExpectedStatusFetcher, as: Fetcher

  setup [:setup_single_api_url, :setup_bulk_api_url, :setup_api_code]

  @tag integration_test: true
  test "fetch_expected_status_single with valid api_code",
    %{single_api_url: single_api_url, api_code_1: api_code_1} do
    {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_single(single_api_url, api_code_1)
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
    %{bulk_api_url: bulk_api_url, api_code_1: api_code_1, api_code_2: api_code_2} do

    {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_bulk(bulk_api_url, [api_code_1, api_code_2])
    assert test_result_e1 == :ok
    assert Map.has_key?(test_result_e2, api_code_1)
    assert Map.has_key?(test_result_e2, api_code_2)

    api_code_1_expected_status = Map.get(test_result_e2, api_code_1)
    assert Map.has_key?(api_code_1_expected_status, "asic_expected_status")
    assert Map.has_key?(api_code_1_expected_status, "light_expected_status")
    assert Map.get(api_code_1_expected_status, "asic_expected_status") in ["on", "off"]
    assert Map.get(api_code_1_expected_status, "light_expected_status") in ["on", "off"]
  end

  @tag integration_test: true
  test "fetch_expected_status_bulk with invalid api_code_list",
    %{bulk_api_url: bulk_api_url, api_code_2: api_code_2} do

    {test_result_e1, test_result_e2} = Fetcher.fetch_expected_status_bulk(bulk_api_url, ["invalid_api_code", api_code_2])
    assert test_result_e1 == :ok
    assert Map.has_key?(test_result_e2, api_code_2)
    refute Map.has_key?(test_result_e2, "invalid_api_code")

    api_code_2_expected_status = Map.get(test_result_e2, api_code_2)
    assert Map.has_key?(api_code_2_expected_status, "asic_expected_status")
    assert Map.has_key?(api_code_2_expected_status, "light_expected_status")
    assert Map.get(api_code_2_expected_status, "asic_expected_status") in ["on", "off"]
    assert Map.get(api_code_2_expected_status, "light_expected_status") in ["on", "off"]
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

  defp setup_api_code(_) do
    %{
      api_code_1: "api_code_1",
      api_code_2: "api_code_2",
    }
  end
end
