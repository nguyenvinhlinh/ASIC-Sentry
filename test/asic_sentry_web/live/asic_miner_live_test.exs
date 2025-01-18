defmodule AsicSentryWeb.AsicMinerLiveTest do
  use AsicSentryWeb.ConnCase

  import Phoenix.LiveViewTest
  import AsicSentry.AsicMinersFixtures

  @create_attrs %{ip: "some ip", api_code: "some api_code", asic_model: "some asic_model"}
  @update_attrs %{ip: "some updated ip", api_code: "some updated api_code", asic_model: "some updated asic_model"}
  @invalid_attrs %{ip: nil, api_code: nil, asic_model: nil}

  defp create_asic_miner(_) do
    asic_miner = asic_miner_fixture()
    %{asic_miner: asic_miner}
  end

  describe "Index" do
    setup [:create_asic_miner]

    test "lists all asic_miners", %{conn: conn, asic_miner: asic_miner} do
      {:ok, _index_live, html} = live(conn, ~p"/asic_miners")

      assert html =~ "Listing Asic miners"
      assert html =~ asic_miner.ip
    end

    test "saves new asic_miner", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")

      assert index_live |> element("a", "New Asic miner") |> render_click() =~
               "New Asic miner"

      assert_patch(index_live, ~p"/asic_miners/new")

      assert index_live
             |> form("#asic_miner-form", asic_miner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#asic_miner-form", asic_miner: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/asic_miners")

      html = render(index_live)
      assert html =~ "Asic miner created successfully"
      assert html =~ "some ip"
    end

    test "updates asic_miner in listing", %{conn: conn, asic_miner: asic_miner} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")

      assert index_live |> element("#asic_miners-#{asic_miner.id} a", "Edit") |> render_click() =~
               "Edit Asic miner"

      assert_patch(index_live, ~p"/asic_miners/#{asic_miner}/edit")

      assert index_live
             |> form("#asic_miner-form", asic_miner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#asic_miner-form", asic_miner: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/asic_miners")

      html = render(index_live)
      assert html =~ "Asic miner updated successfully"
      assert html =~ "some updated ip"
    end

    test "deletes asic_miner in listing", %{conn: conn, asic_miner: asic_miner} do
      {:ok, index_live, _html} = live(conn, ~p"/asic_miners")

      assert index_live |> element("#asic_miners-#{asic_miner.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#asic_miners-#{asic_miner.id}")
    end
  end

  describe "Show" do
    setup [:create_asic_miner]

    test "displays asic_miner", %{conn: conn, asic_miner: asic_miner} do
      {:ok, _show_live, html} = live(conn, ~p"/asic_miners/#{asic_miner}")

      assert html =~ "Show Asic miner"
      assert html =~ asic_miner.ip
    end

    test "updates asic_miner within modal", %{conn: conn, asic_miner: asic_miner} do
      {:ok, show_live, _html} = live(conn, ~p"/asic_miners/#{asic_miner}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Asic miner"

      assert_patch(show_live, ~p"/asic_miners/#{asic_miner}/show/edit")

      assert show_live
             |> form("#asic_miner-form", asic_miner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#asic_miner-form", asic_miner: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/asic_miners/#{asic_miner}")

      html = render(show_live)
      assert html =~ "Asic miner updated successfully"
      assert html =~ "some updated ip"
    end
  end
end
