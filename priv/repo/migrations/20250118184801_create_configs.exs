defmodule AsicSentry.Repo.Migrations.CreateConfigs do
  use Ecto.Migration

  def change do
    create table(:configs) do
      add :key, :string
      add :value, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:configs, [:key])
  end
end
