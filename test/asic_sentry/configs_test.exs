defmodule AsicSentry.ConfigsTest do
  use AsicSentry.DataCase

  alias AsicSentry.Configs

  describe "configs" do
    alias AsicSentry.Configs.Config

    import AsicSentry.ConfigsFixtures

    @invalid_attrs %{value: nil, key: nil}

    test "list_configs/0 returns all configs" do
      config = config_fixture()
      assert Configs.list_configs() == [config]
    end

    test "get_config!/1 returns the config with given id" do
      config = config_fixture()
      assert Configs.get_config!(config.id) == config
    end

    test "create_config/1 with valid data creates a config" do
      valid_attrs = %{value: "some value", key: "mininig_rig_commander_api_url"}

      assert {:ok, %Config{} = config} = Configs.create_config(valid_attrs)
      assert config.value == "some value"
      assert config.key == "mininig_rig_commander_api_url"
    end

    test "create_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Configs.create_config(@invalid_attrs)
    end

    test "update_config/2 with valid data updates the config" do
      config = config_fixture()
      update_attrs = %{value: "some updated value", key: "mininig_rig_commander_api_url"}

      assert {:ok, %Config{} = config} = Configs.update_config(config, update_attrs)
      assert config.value == "some updated value"
      assert config.key == "mininig_rig_commander_api_url"
    end

    test "update_config/2 with invalid data returns error changeset" do
      config = config_fixture()
      assert {:error, %Ecto.Changeset{}} = Configs.update_config(config, @invalid_attrs)
      assert config == Configs.get_config!(config.id)
    end

    test "delete_config/1 deletes the config" do
      config = config_fixture()
      assert {:ok, %Config{}} = Configs.delete_config(config)
      assert_raise Ecto.NoResultsError, fn -> Configs.get_config!(config.id) end
    end

    test "change_config/1 returns a config changeset" do
      config = config_fixture()
      assert %Ecto.Changeset{} = Configs.change_config(config)
    end
  end
end
