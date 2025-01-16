defmodule AsicSentryWeb.AsicMinerController do
  use AsicSentryWeb, :controller

  alias AsicSentry.AsicMiners
  alias AsicSentry.AsicMiners.AsicMiner

  def index(conn, _params) do
    asic_miners = AsicMiners.list_asic_miners()
    render(conn, :index, asic_miners: asic_miners)
  end

  def new(conn, _params) do
    changeset = AsicMiners.change_asic_miner(%AsicMiner{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"asic_miner" => asic_miner_params}) do
    case AsicMiners.create_asic_miner(asic_miner_params) do
      {:ok, asic_miner} ->
        conn
        |> put_flash(:info, "Asic miner created successfully.")
        |> redirect(to: ~p"/asic_miners/#{asic_miner}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    render(conn, :show, asic_miner: asic_miner)
  end

  def edit(conn, %{"id" => id}) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    changeset = AsicMiners.change_asic_miner(asic_miner)
    render(conn, :edit, asic_miner: asic_miner, changeset: changeset)
  end

  def update(conn, %{"id" => id, "asic_miner" => asic_miner_params}) do
    asic_miner = AsicMiners.get_asic_miner!(id)

    case AsicMiners.update_asic_miner(asic_miner, asic_miner_params) do
      {:ok, asic_miner} ->
        conn
        |> put_flash(:info, "Asic miner updated successfully.")
        |> redirect(to: ~p"/asic_miners/#{asic_miner}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, asic_miner: asic_miner, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    {:ok, _asic_miner} = AsicMiners.delete_asic_miner(asic_miner)

    conn
    |> put_flash(:info, "Asic miner deleted successfully.")
    |> redirect(to: ~p"/asic_miners")
  end
end
