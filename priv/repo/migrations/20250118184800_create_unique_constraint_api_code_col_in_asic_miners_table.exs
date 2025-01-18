defmodule AsicSentry.Repo.Migrations.CreateUniqueConstraintApiCodeColInAsicMinersTable do
  use Ecto.Migration

  def change do
    create unique_index(:asic_miners, [:api_code])
  end
end
