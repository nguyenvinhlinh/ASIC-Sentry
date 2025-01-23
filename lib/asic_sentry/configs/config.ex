defmodule AsicSentry.Configs.Config do
  use Ecto.Schema
  import Ecto.Changeset

  @available_key_list ["mininig_rig_commander_api_url"]

  schema "configs" do
    field :value, :string
    field :key, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> unique_constraint([:key])
    |> validate_inclusion(:key, @available_key_list)
  end

  def get_available_key_list(), do: @available_key_list
end
