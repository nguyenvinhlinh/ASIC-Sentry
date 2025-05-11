defmodule AsicSentryWeb.AsicMinerLive.New do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.AsicMiners
  alias AsicSentry.AsicMiners.AsicMiner

  @impl true
  def mount(_params, _session, socket) do
    asic_model_option_list = AsicMiner.get_available_asic_model_list()
    form = %AsicMiner{}
    |> AsicMiners.change_asic_miner()
    |> to_form()

    socket_mod = socket
    |> assign(:asic_model_option_list, asic_model_option_list)
    |> assign(:form, form)
    {:ok, socket_mod}
  end

  @impl true
  def handle_event("validate", %{"asic_miner" => asic_miner_params}, socket) do
    form = %AsicMiner{}
    |> AsicMiners.change_asic_miner(asic_miner_params)
    |> to_form(action: :validate)
    socket_mod = socket
    |> assign(:form, form)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_event("save", %{"asic_miner" => asic_miner_params}, socket) do
    case AsicMiners.create_asic_miner(asic_miner_params) do
      {:ok, asic_miner} ->
        message = "ASIC Miner ##{asic_miner.id} created successfully."
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
