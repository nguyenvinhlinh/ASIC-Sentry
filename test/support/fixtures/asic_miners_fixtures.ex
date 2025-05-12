defmodule AsicSentry.AsicMinersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AsicSentry.AsicMiners` context.
  """

  @doc """
  Generate a asic_miner.
  """
  def asic_miner_fixture(attrs \\ %{}) do
    {:ok, asic_miner} =
      attrs
      |> Enum.into(%{
        api_code: "some api_code",
        asic_model: "Ice River - KS5L",
        ip: "some ip",
        asic_expected_status: "off",
        light_expected_status: "off"
      })
      |> AsicSentry.AsicMiners.create_asic_miner()

    asic_miner
  end
end
