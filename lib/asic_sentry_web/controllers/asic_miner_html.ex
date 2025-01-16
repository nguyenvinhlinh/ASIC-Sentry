defmodule AsicSentryWeb.AsicMinerHTML do
  use AsicSentryWeb, :html

  embed_templates "asic_miner_html/*"

  @doc """
  Renders a asic_miner form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def asic_miner_form(assigns)
end
