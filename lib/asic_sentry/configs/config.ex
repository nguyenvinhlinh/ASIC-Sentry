defmodule AsicSentry.Configs.Config do
  use Ecto.Schema
  import Ecto.Changeset

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
  end
end
