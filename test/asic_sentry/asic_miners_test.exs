defmodule AsicSentry.AsicMinersTest do
  use AsicSentry.DataCase

  alias AsicSentry.AsicMiners

  describe "asic_miners" do
    alias AsicSentry.AsicMiners.AsicMiner

    import AsicSentry.AsicMinersFixtures

    @invalid_attrs %{ip: nil, api_code: nil, asic_model: nil}

    test "list_asic_miners/0 returns all asic_miners" do
      asic_miner = asic_miner_fixture()
      assert AsicMiners.list_asic_miners() == [asic_miner]
    end

    test "get_asic_miner!/1 returns the asic_miner with given id" do
      asic_miner = asic_miner_fixture()
      assert AsicMiners.get_asic_miner!(asic_miner.id) == asic_miner
    end

    test "create_asic_miner/1 with valid data creates a asic_miner" do
      valid_attrs = %{ip: "some ip", api_code: "some api_code", asic_model: "some asic_model"}

      assert {:ok, %AsicMiner{} = asic_miner} = AsicMiners.create_asic_miner(valid_attrs)
      assert asic_miner.ip == "some ip"
      assert asic_miner.api_code == "some api_code"
      assert asic_miner.asic_model == "some asic_model"
    end

    test "create_asic_miner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AsicMiners.create_asic_miner(@invalid_attrs)
    end

    test "update_asic_miner/2 with valid data updates the asic_miner" do
      asic_miner = asic_miner_fixture()
      update_attrs = %{ip: "some updated ip", api_code: "some updated api_code", asic_model: "some updated asic_model"}

      assert {:ok, %AsicMiner{} = asic_miner} = AsicMiners.update_asic_miner(asic_miner, update_attrs)
      assert asic_miner.ip == "some updated ip"
      assert asic_miner.api_code == "some updated api_code"
      assert asic_miner.asic_model == "some updated asic_model"
    end

    test "update_asic_miner/2 with invalid data returns error changeset" do
      asic_miner = asic_miner_fixture()
      assert {:error, %Ecto.Changeset{}} = AsicMiners.update_asic_miner(asic_miner, @invalid_attrs)
      assert asic_miner == AsicMiners.get_asic_miner!(asic_miner.id)
    end

    test "delete_asic_miner/1 deletes the asic_miner" do
      asic_miner = asic_miner_fixture()
      assert {:ok, %AsicMiner{}} = AsicMiners.delete_asic_miner(asic_miner)
      assert_raise Ecto.NoResultsError, fn -> AsicMiners.get_asic_miner!(asic_miner.id) end
    end

    test "change_asic_miner/1 returns a asic_miner changeset" do
      asic_miner = asic_miner_fixture()
      assert %Ecto.Changeset{} = AsicMiners.change_asic_miner(asic_miner)
    end
  end
end
