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

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AsicSentry.PubSub, "asic_miner_index_channel")
      Phoenix.PubSub.subscribe(AsicSentry.PubSub, "flash_index_channel")
    end

    {:ok, socket_mod}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    {:ok, _} = AsicMiners.delete_asic_miner(asic_miner)

    message = "ASIC Miner ##{asic_miner.id} deleted."
    Phoenix.PubSub.broadcast(AsicSentry.PubSub, "asic_miner_index_channel", {:asic_miner_index_channel, :delete, asic_miner})
    Phoenix.PubSub.broadcast(AsicSentry.PubSub, "flash_index_channel", {:flash_index_channel, :info, message})

    socket_mod = socket
    |> put_flash(:info, message)
    |> stream_delete(:asic_miner_list, asic_miner)

    {:noreply, socket_mod}
  end

  @impl true
  def handle_info({:asic_miner_index_channel, :create_or_update, asic_miner}, socket) do
    socket_mod = socket
    |> stream_insert(:asic_miner_list, asic_miner)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_info({:asic_miner_index_channel, :delete, asic_miner}, socket) do
    socket_mod = socket
    |> stream_delete(:asic_miner_list, asic_miner)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_info({:flash_index_channel, flash_type, message}, socket) do
    socket_mod = put_flash(socket, flash_type, message)
    {:noreply, socket_mod}
  end

  def css_class_asic_expected_status(asic_miner) do
    if asic_miner.asic_expected_status == "on" do
      "badge badge-success"
    else
      "badge badge-error"
    end
  end

  def css_class_light_expected_status(asic_miner) do
    if asic_miner.light_expected_status == "on" do
      "badge badge-success"
    else
      "badge badge-error"
    end
  end
end
