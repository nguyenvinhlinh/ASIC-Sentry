defmodule AsicSentry.ConfigsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AsicSentry.Configs` context.
  """

  @doc """
  Generate a config.
  """
  def config_fixture(attrs \\ %{}) do
    {:ok, config} =
      attrs
      |> Enum.into(%{
          key: "mininig_rig_commander_api_url",
          value: "http://mining-rig-commander.xyz/api/v1"
      })
      |> AsicSentry.Configs.create_config()

    config
  end
end
