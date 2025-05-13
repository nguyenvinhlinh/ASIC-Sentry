defmodule AsicSentryWeb.ConfigLiveTest do
  use AsicSentryWeb.ConnCase

  import Phoenix.LiveViewTest
  import AsicSentry.ConfigsFixtures

  @create_attrs %{value: "http://mining-rig-commander.xyz/api/v1",   key: "mininig_rig_commander_api_url"}
  @update_attrs %{value: "http://mining-rig-commander.local/api/v1", key: "mininig_rig_commander_api_url"}
  @invalid_attrs %{value: nil, key: "mininig_rig_commander_api_url"}

  defp create_config(_) do
    config = config_fixture()
    %{config: config}
  end

  describe "Index module" do
    setup [:create_config]

    test "lists all configs", %{conn: conn, config: config} do
      {:ok, index_live, html} = live(conn, ~p"/configs")

      assert html =~ "ASIC Sentry Configs"
      assert html =~ config.value
      assert has_element?(index_live, "#config_list-#{config.id}")
      assert html =~ config.key
      assert html =~ config.value
    end

    test "redirect to new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      index_live
      |> element("#config_new")
      |> render_click()

      assert_redirect(index_live, ~p"/configs/new", 100)
    end

    test "redirect to edit page", %{conn: conn, config: config} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      index_live
      |> element("#config-#{config.id}-edit")
      |> render_click()

      assert_redirect(index_live, ~p"/configs/#{config.id}/edit", 100)
    end

    test "deletes config in listing", %{conn: conn, config: config} do
      {:ok, index_live, _html} = live(conn, ~p"/configs")

      assert has_element?(index_live, "#config_list-#{config.id}")
      index_live
      |> element("#config-#{config.id}-delete")
      |> render_click()
      refute has_element?(index_live, "#configs_list-#{config.id}")
    end
  end

  describe "New module" do
    test "save config", %{conn: conn} do
      {:ok, new_live, new_html} = live(conn, ~p"/configs/new")
      assert new_html =~ "Create new Config"


      assert new_live
      |> form("#config_new_form", %{"config" => @invalid_attrs})
      |> render_change() =~ "can&#39;t be blank"

      new_live
      |> form("#config_new_form", %{"config" => @create_attrs})
      |> render_submit()

      assert_redirect(new_live, ~p"/configs", 100)

      {:ok, _index_live, index_html} = live(conn, ~p"/configs")

      assert index_html =~ "mininig_rig_commander_api_url"
      assert index_html =~ "http://mining-rig-commander.xyz/api/v1"
    end
  end

  describe "Edit module" do
    setup [:create_config]

    test "edit config", %{conn: conn, config: config} do
      {:ok, edit_live, edit_html} = live(conn, ~p"/configs/#{config.id}/edit")
      assert edit_html =~ "Edit Config"

      assert edit_live
      |> form("#config_edit_form", %{"config" => @invalid_attrs})
      |> render_change =~ "can&#39;t be blank"

      edit_live
      |> form("#config_edit_form", %{"config" => @update_attrs})
      |> render_submit()

      assert_redirect(edit_live, ~p"/configs", 100)

      {:ok, _index_live, index_html} = live(conn, ~p"/configs")
      assert index_html =~ "http://mining-rig-commander.local/api/v1"
    end
  end
end
