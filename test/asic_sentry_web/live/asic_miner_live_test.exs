defmodule AsicSentryWeb.AsicMinerLiveTest do
  use AsicSentryWeb.ConnCase

  import Phoenix.LiveViewTest
  import AsicSentry.AsicMinersFixtures

  @create_attrs %{ip: "192.168.1.10", api_code: "111-222-333", asic_model: "Ice River - KS5L"}
  @update_attrs %{ip: "192.168.1.11", api_code: "222-333-444", asic_model: "Ice River - KS5L", rrc_serial_number: "rrc-serial-no"}
  @invalid_attrs %{ip: nil, api_code: nil, asic_model: "Ice River - KS5L"}

  defp create_asic_miner(_) do
    asic_miner = asic_miner_fixture()
    %{asic_miner: asic_miner}
  end

  describe "Index" do
    setup [:create_asic_miner]

    test "lists all asic_miners", %{conn: conn, asic_miner: asic_miner} do
      {:ok, _index_live, html} = live(conn, ~p"/asic_miners")

      assert html =~ "ASIC Miners"
      assert html =~ asic_miner.ip
      assert html =~ asic_miner.api_code
    end

    test "redirect to asic miner new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")
      index_live
      |> element("#asic_miner_new")
      |> render_click()

      assert_redirect(index_live, ~p"/asic_miners/new", 100)
    end

    test "redirect to asic miner edit page", %{conn: conn, asic_miner: asic_miner} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")
      index_live
      |> element("#asic_miner-#{asic_miner.id}-edit")
      |> render_click()

      assert_redirect(index_live, ~p"/asic_miners/#{asic_miner.id}/edit", 100)
    end

    test "deletes asic_miner in listing", %{conn: conn, asic_miner: asic_miner} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")
      assert has_element?(index_live, "#asic_miner_list-#{asic_miner.id}")
      index_live |> element("#asic_miner-#{asic_miner.id}-delete") |> render_click()
      refute has_element?(index_live, "#asic_miner_list-#{asic_miner.id}")
    end
  end

  test "create new asic miner", %{conn: conn} do
    {:ok, new_live, new_html} = live(conn, ~p"/asic_miners/new")
    assert new_html =~ "Create new ASIC Miners"

    assert new_live
    |> form("#asic_miner_new_form", %{asic_miner: @invalid_attrs})
    |> render_change() =~ "can&#39;t be blank"

    new_live
    |> form("#asic_miner_new_form", %{asic_miner: @create_attrs})
    |> render_submit()

    assert_redirect(new_live, ~p"/asic_miners", 100)
    {:ok, _index_live, index_html} = live(conn, ~p"/asic_miners")
    assert index_html =~ "192.168.1.10"
    assert index_html =~ "111-222-333"
  end

  test "edit asic miner", %{conn: conn} do
    asic_miner = asic_miner_fixture()

    {:ok, edit_live, edit_html} = live(conn, ~p"/asic_miners/#{asic_miner.id}/edit")
    assert edit_html =~ "Edit ASIC Miners"

    assert edit_live
    |> form("#asic_miner_edit_form", %{asic_miner: @invalid_attrs})
    |> render_change() =~ "can&#39;t be blank"

    edit_live
    |> form("#asic_miner_edit_form", %{asic_miner: @update_attrs})
    |> render_submit()

    assert_redirect(edit_live, ~p"/asic_miners", 100)

    {:ok, _index_live, index_html} = live(conn, ~p"/asic_miners")
    assert index_html =~ "192.168.1.11"
    assert index_html =~ "222-333-444"
    assert index_html =~ "rrc-serial-no"
  end
end
