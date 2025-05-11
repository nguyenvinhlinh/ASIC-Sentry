defmodule AsicSentryWeb.ConfigLive.New do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.Configs
  alias AsicSentry.Configs.Config

  @impl true
  def mount(_params, _session, socket) do
    key_option_list = Config.get_available_key_list
    form = %Config{}
    |> Configs.change_config()
    |> to_form()

    socket_mod = socket
    |> assign(:key_option_list, key_option_list)
    |> assign(:form, form)
    {:ok, socket_mod}
  end

  @impl true
  def handle_event("validate", %{"config" => config_params}, socket) do
    form = %Config{}
    |> Configs.change_config(config_params)
    |> to_form(action: :validate)
    socket_mod = socket
    |> assign(:form, form)
    {:noreply, socket_mod}
  end

  @impl true
  def handle_event("save", %{"config" => config_params}, socket) do
    case Configs.create_config(config_params) do
      {:ok, config} ->
        message = "Config ##{config.id} created successfully."
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
