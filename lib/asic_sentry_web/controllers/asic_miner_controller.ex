defmodule AsicSentryWeb.AsicMinerController do
  use AsicSentryWeb, :controller

  def get_expected_status(conn, _params) do
    asic_miner = conn.assigns[:asic_miner]
    data = Map.take(asic_miner, [:name, :asic_expected_status, :light_expected_status])
    json(conn, data)
  end
end
