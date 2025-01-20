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
    |> validate_required([:api_code, :asic_model, :ip])
    |> unique_constraint([:api_code])
  end

  def get_available_asic_model_list(), do: @available_asic_model_list
end
