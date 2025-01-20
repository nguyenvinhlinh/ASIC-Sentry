defmodule AsicSentry.AsicMiners.AsicMiner do
  use Ecto.Schema
  import Ecto.Changeset
  @available_asic_model_list [
    "Ice River - KS5L"
  ]

  schema "asic_miners" do
    field :ip, :string
    field :api_code, :string
    field :asic_model, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(asic_miner, attrs) do
    asic_miner
    |> cast(attrs, [:api_code, :asic_model, :ip])
    |> update_change(:api_code, &trim/1)
    |> update_change(:ip, &trim/1)
    |> validate_required([:api_code, :asic_model, :ip])
    |> unique_constraint([:api_code])
  end

  def get_available_asic_model_list(), do: @available_asic_model_list

  defp trim(binary) when is_binary(binary), do: String.trim(binary)
  defp trim(nil), do: nil
end
