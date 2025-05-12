defmodule AsicSentry.Repo.Migrations.AddNameToAsicMinersTable do
  use Ecto.Migration

  def change do
    alter table(:asic_miners) do
      add :name, :string
    end
  end
end
