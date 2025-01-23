defmodule AsicSentryWeb.ConfigLiveTest do
  use AsicSentryWeb.ConnCase

  import Phoenix.LiveViewTest
  import AsicSentry.ConfigsFixtures

  @create_attrs %{value: "some value",   key: "mininig_rig_commander_api_url"}
  @update_attrs %{value: "some updated value", key: "mininig_rig_commander_api_url"}
  @invalid_attrs %{value: nil, key: "mininig_rig_commander_api_url"}

  defp create_config(_) do
    config = config_fixture()
    %{config: config}
  end

  describe "Index with setup create_config" do
    setup [:create_config]

    test "lists all configs", %{conn: conn, config: config} do
      {:ok, _index_live, html} = live(conn, ~p"/configs")

      assert html =~ "Listing Configs"
      assert html =~ config.value
    end

    test "updates config in listing", %{conn: conn, config: config} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      assert index_live |> element("#configs-#{config.id} a", "Edit") |> render_click() =~
               "Edit Config"

      assert_patch(index_live, ~p"/configs/#{config}/edit")

      assert index_live
             |> form("#config-form", config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#config-form", config: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/configs")

      html = render(index_live)
      assert html =~ "Config updated successfully"
      assert html =~ "some updated value"
    end

    test "deletes config in listing", %{conn: conn, config: config} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      assert index_live |> element("#configs-#{config.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#configs-#{config.id}")
    end
  end

  describe "Index without setup create_config " do
    test "saves new config", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      assert index_live |> element("a", "New Config") |> render_click() =~
               "New Config"

      assert_patch(index_live, ~p"/configs/new")

      assert index_live
             |> form("#config-form", config: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#config-form", config: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/configs")

      html = render(index_live)
      assert html =~ "Config created successfully"
      assert html =~ "some value"
    end


  end
end
