defmodule AsicSentry.AsicMiners.AsicMiner do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @available_asic_model_list [
    "Ice River - KS5L"
  ]

  @asic_miner_model_and_module_map %{
    "Ice River - KS5L" => AsicSentry.Miners.IceRiverKS5L
  }

  @asic_expected_status_on   "on"
  @asic_expected_status_off  "off"
  @light_expected_status_on  "on"
  @light_expected_status_off "off"

  schema "asic_miners" do
    field :name, :string
    field :ip, :string
    field :api_code, :string
    field :asic_model, :string
    field :asic_expected_status, :string
    field :light_expected_status, :string
    field :rrc_serial_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(asic_miner, attrs) do
    Logger.warning("[#{__MODULE__}] changeset/2, change to changeset_by_sentry")
    asic_miner
    |> cast(attrs, [:api_code, :asic_model, :ip, :rrc_serial_number])
    |> update_change(:api_code, &trim/1)
    |> update_change(:ip, &trim/1)
    |> update_change(:rrc_serial_number, &trim/1)
    |> validate_required([:api_code, :asic_model, :ip])
    |> validate_inclusion(:asic_model, @available_asic_model_list)
    |> unique_constraint([:api_code])
    |> unique_constraint([:rrc_serial_number])
  end

  @doc false
  def changeset_by_sentry(asic_miner, attrs) do
    asic_miner
    |> cast(attrs, [:api_code, :asic_model, :ip, :rrc_serial_number])
    |> update_change(:api_code, &trim/1)
    |> update_change(:ip, &trim/1)
    |> update_change(:rrc_serial_number, &trim/1)
    |> validate_required([:api_code, :asic_model, :ip])
    |> validate_inclusion(:asic_model, @available_asic_model_list)
    |> unique_constraint([:api_code])
    |> unique_constraint([:rrc_serial_number])
  end

  def changeset_update_by_commander(asic_miner, attrs) do
    asic_miner
    |> cast(attrs, [:name, :asic_expected_status, :light_expected_status])
    |> validate_required([:asic_expected_status, :light_expected_status])
    |> validate_inclusion(:asic_expected_status,  [@asic_expected_status_on,  @asic_expected_status_off])
    |> validate_inclusion(:light_expected_status, [@light_expected_status_on, @light_expected_status_off])
  end

  def get_available_asic_model_list(), do: @available_asic_model_list

  def get_asic_miner_module(asic_model) do
    asic_miner_module = Map.get(@asic_miner_model_and_module_map, asic_model, nil)
    if Kernel.is_nil(asic_miner_module) do
      {:error, :invalid_asic_model}
    else
      {:ok, asic_miner_module}
    end
  end

  defp trim(binary) when is_binary(binary), do: String.trim(binary)
  defp trim(nil), do: nil
end
