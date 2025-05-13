defmodule AsicSentryWeb.AsicMinerLive.Index do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.AsicMiners

  embed_templates "index_html/*"

  @impl true
  def mount(_params, _session, socket) do
    asic_miner_list = AsicMiners.list_asic_miners()
    socket_mod = socket
    |> assign(:page_title, "ASIC Miner Index")
    |> stream(:asic_miner_list, asic_miner_list)

    {:ok, socket_mod}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket

  end

  @impl true
  def handle_info({AsicSentryWeb.AsicMinerLive.FormComponent, {:saved, asic_miner}}, socket) do
    {:noreply, stream_insert(socket, :asic_miners, asic_miner)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    {:ok, _} = AsicMiners.delete_asic_miner(asic_miner)

    message = "ASIC Miner ##{asic_miner.id} deleted."
    socket_mod = socket
    |> put_flash(:info, message)
    |> stream_delete(:asic_miner_list, asic_miner)

    {:noreply, socket_mod}
  end
end
