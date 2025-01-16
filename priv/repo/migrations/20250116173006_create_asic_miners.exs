defmodule AsicSentry.Repo.Migrations.CreateAsicMiners do
  use Ecto.Migration

  def change do
    create table(:asic_miners) do
      add :api_code, :string
      add :asic_model, :string
      add :ip, :string

      timestamps(type: :utc_datetime)
    end
  end
end
