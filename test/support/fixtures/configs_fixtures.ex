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
        key: "some key",
        value: "some value"
      })
      |> AsicSentry.Configs.create_config()

    config
  end
end
