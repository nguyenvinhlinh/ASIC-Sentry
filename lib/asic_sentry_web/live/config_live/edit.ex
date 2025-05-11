defmodule AsicSentryWeb.ConfigLive.Edit do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.Configs
  alias AsicSentry.Configs.Config

  @impl true
  def mount(%{"id" => id}, _session, socket) do

    config = Configs.get_config!(id)
    key_option_list = Config.get_available_key_list()
    form = config
    |> Configs.change_config()
    |> to_form()

    socket_mod = socket
    |> assign(:config, config)
    |> assign(:key_option_list, key_option_list)
    |> assign(:form, form)
    {:ok, socket_mod}
  end

  @impl true
  def handle_event("validate", %{"config" => config_params}, socket) do

    form = socket.assigns[:config]
    |> Configs.change_config(config_params)
    |> to_form(action: :validate)
    socket_mod = socket
    |> assign(:form, form)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_event("save", %{"config" => config_params}, socket) do
    config = socket.assigns[:config]
    case Configs.update_config(config, config_params) do
      {:ok, config} ->
        message = "Config ##{config.id} updated successfully."
        socket_mod = socket
        |> put_flash(:info, message)
        |> redirect(to: ~p"/configs")
        {:noreply, socket_mod}
      {:error, changeset} ->
        form = to_form(changeset)
        socket_mod = socket
        |> assign(:form, form)
        {:noreply, socket_mod}
    end
  end
end
