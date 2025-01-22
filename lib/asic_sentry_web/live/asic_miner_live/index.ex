defmodule AsicSentryWeb.AsicMinerLive.Index do
  use AsicSentryWeb, :live_view

  alias AsicSentry.AsicMiners
  alias AsicSentry.AsicMiners.AsicMiner
  embed_templates "index_html/*"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :asic_miners, AsicMiners.list_asic_miners())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    asic_model_option_list = AsicMiner.get_available_asic_model_list()

    socket
    |> assign(:page_title, "Edit ASIC Miner")
    |> assign(:asic_model_option_list, asic_model_option_list)
    |> assign(:asic_miner, AsicMiners.get_asic_miner!(id))
  end

  defp apply_action(socket, :new, _params) do
    asic_model_option_list = AsicMiner.get_available_asic_model_list()
    socket
    |> assign(:page_title, "New ASIC Miner")
    |> assign(:asic_model_option_list, asic_model_option_list)
    |> assign(:asic_miner, %AsicMiner{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing ASIC Miners")
    |> assign(:asic_miner, nil)
  end

  @impl true
  def handle_info({AsicSentryWeb.AsicMinerLive.FormComponent, {:saved, asic_miner}}, socket) do
    {:noreply, stream_insert(socket, :asic_miners, asic_miner)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    {:ok, _} = AsicMiners.delete_asic_miner(asic_miner)

    {:noreply, stream_delete(socket, :asic_miners, asic_miner)}
  end
end
