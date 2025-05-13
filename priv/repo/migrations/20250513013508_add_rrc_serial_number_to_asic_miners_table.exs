defmodule AsicSentry.Repo.Migrations.AddRrcSerialNumberToAsicMinersTable do
  use Ecto.Migration

  def change do
    alter table(:asic_miners) do
      add :rrc_serial_number, :string
    end

    create unique_index(:asic_miners, [:rrc_serial_number])
  end
end
