defmodule AsicSentryWeb.AsicMinerControllerTest do
  use AsicSentryWeb.ConnCase

  import AsicSentry.AsicMinersFixtures

  @create_attrs %{ip: "some ip", api_code: "some api_code", asic_model: "some asic_model"}
  @update_attrs %{ip: "some updated ip", api_code: "some updated api_code", asic_model: "some updated asic_model"}
  @invalid_attrs %{ip: nil, api_code: nil, asic_model: nil}

  describe "index" do
    test "lists all asic_miners", %{conn: conn} do
      conn = get(conn, ~p"/asic_miners")
      assert html_response(conn, 200) =~ "Listing Asic miners"
    end
  end

  describe "new asic_miner" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/asic_miners/new")
      assert html_response(conn, 200) =~ "New Asic miner"
    end
  end

  describe "create asic_miner" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/asic_miners", asic_miner: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/asic_miners/#{id}"

      conn = get(conn, ~p"/asic_miners/#{id}")
      assert html_response(conn, 200) =~ "Asic miner #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/asic_miners", asic_miner: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Asic miner"
    end
  end

  describe "edit asic_miner" do
    setup [:create_asic_miner]

    test "renders form for editing chosen asic_miner", %{conn: conn, asic_miner: asic_miner} do
      conn = get(conn, ~p"/asic_miners/#{asic_miner}/edit")
      assert html_response(conn, 200) =~ "Edit Asic miner"
    end
  end

  describe "update asic_miner" do
    setup [:create_asic_miner]

    test "redirects when data is valid", %{conn: conn, asic_miner: asic_miner} do
      conn = put(conn, ~p"/asic_miners/#{asic_miner}", asic_miner: @update_attrs)
      assert redirected_to(conn) == ~p"/asic_miners/#{asic_miner}"

      conn = get(conn, ~p"/asic_miners/#{asic_miner}")
      assert html_response(conn, 200) =~ "some updated ip"
    end

    test "renders errors when data is invalid", %{conn: conn, asic_miner: asic_miner} do
      conn = put(conn, ~p"/asic_miners/#{asic_miner}", asic_miner: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Asic miner"
    end
  end

  describe "delete asic_miner" do
    setup [:create_asic_miner]

    test "deletes chosen asic_miner", %{conn: conn, asic_miner: asic_miner} do
      conn = delete(conn, ~p"/asic_miners/#{asic_miner}")
      assert redirected_to(conn) == ~p"/asic_miners"

      assert_error_sent 404, fn ->
        get(conn, ~p"/asic_miners/#{asic_miner}")
      end
    end
  end

  defp create_asic_miner(_) do
    asic_miner = asic_miner_fixture()
    %{asic_miner: asic_miner}
  end
end
