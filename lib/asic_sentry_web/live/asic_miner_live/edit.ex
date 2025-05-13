defmodule AsicSentryWeb.AsicMinerLive.Edit do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.AsicMiners
  alias AsicSentry.AsicMiners.AsicMiner

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    asic_miner = AsicMiners.get_asic_miner!(id)
    asic_model_option_list = AsicMiner.get_available_asic_model_list()
    form = asic_miner
    |> AsicMiners.change_asic_miner()
    |> to_form()

    socket_mod = socket
    |> assign(:asic_miner, asic_miner)
    |> assign(:asic_model_option_list, asic_model_option_list)
    |> assign(:form, form)
    {:ok, socket_mod}
  end

  @impl true
  def handle_event("validate", %{"asic_miner" => asic_miner_params}, socket) do
    asic_miner = socket.assigns[:asic_miner]
    form = asic_miner
    |> AsicMiners.change_asic_miner(asic_miner_params)
    |> to_form(action: :validate)
    socket_mod = socket
    |> assign(:form, form)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_event("save", %{"asic_miner" => asic_miner_params}, socket) do
    asic_miner = socket.assigns[:asic_miner]
    case AsicMiners.update_asic_miner(asic_miner, asic_miner_params) do
      {:ok, asic_miner} ->
        message = "ASIC Miner ##{asic_miner.id} updated successfully."
        Phoenix.PubSub.broadcast(AsicSentry.PubSub, "asic_miner_index_channel", {:asic_miner_index_channel, :create_or_update, asic_miner})
        Phoenix.PubSub.broadcast(AsicSentry.PubSub, "flash_index_channel", {:flash_index_channel, :info, message})
        socket_mod = socket
        |> put_flash(:info, message)
        |> redirect(to: ~p"/asic_miners")
        {:noreply, socket_mod}
      {:error, changeset} ->
        form = to_form(changeset)
        socket_mod = socket
        |> assign(:form, form)
        {:noreply, socket_mod}
    end
  end
end
