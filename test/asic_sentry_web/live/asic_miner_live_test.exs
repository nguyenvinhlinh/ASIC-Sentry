defmodule AsicSentryWeb.AsicMinerLiveTest do
  use AsicSentryWeb.ConnCase

  import Phoenix.LiveViewTest
  import AsicSentry.AsicMinersFixtures

  @create_attrs %{ip: "192.168.1.10", api_code: "111-222-333", asic_model: "Ice River - KS5L"}
  @update_attrs %{ip: "some updated ip", api_code: "222-333-444", asic_model: "Ice River - KS5L"}
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
      {:ok, index_live, html} = live(conn, ~p"/asic_miners")
      index_live
      |> element("#asic_miner_new")
      |> render_click()

      assert_redirect(index_live, ~p"/asic_miners/new", 100)
    end

    test "redirect to asic miner edit page", %{conn: conn, asic_miner: asic_miner} do
      {:ok, index_live, html} = live(conn, ~p"/asic_miners")
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
end




    # test "saves new asic_miner", %{conn: conn} do
    #   {:ok, index_live, _html} = live(conn, ~p"/asic_miners")

    #   assert index_live |> element("a", "New ASIC Miner") |> render_click() =~
    #     "New ASIC Miner"

    #   assert_patch(index_live, ~p"/asic_miners/new")

    #   assert index_live
    #   |> form("#asic_miner-form", asic_miner: @invalid_attrs)
    #   |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #   |> form("#asic_miner-form", asic_miner: @create_attrs)
    #   |> render_submit()


    #   assert_patch(index_live, ~p"/asic_miners")

    #   html = render(index_live)
    #   assert html =~ "ASIC miner created successfully"
    #   assert html =~ "111-222-333"
    #   assert html =~ "192.168.1.10"
    # end

    # test "updates asic_miner in listing", %{conn: conn, asic_miner: asic_miner} do
    #   {:ok, index_live, _html} = live(conn, ~p"/asic_miners")

    #   assert index_live |> element("#asic_miners-#{asic_miner.id} a", "Edit") |> render_click() =~
    #            "Edit ASIC Miner"

    #   assert_patch(index_live, ~p"/asic_miners/#{asic_miner}/edit")

    #   assert index_live
    #   |> form("#asic_miner-form", asic_miner: @invalid_attrs)
    #   |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #   |> form("#asic_miner-form", asic_miner: @update_attrs)
    #   |> render_submit()

    #   assert_patch(index_live, ~p"/asic_miners")

    #   html = render(index_live)
    #   assert html =~ "ASIC miner updated successfully"
    #   assert html =~ "some updated ip"
    #   assert html =~ "222-333-444"
    # end
