defmodule AsicSentryWeb.ConfigLive.Index do
  use AsicSentryWeb, :live_view

  alias AsicSentry.Configs
  alias AsicSentry.Configs.Config

  embed_templates "index_html/*"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :configs, Configs.list_configs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Config")
    |> assign(:config, Configs.get_config!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Config")
    |> assign(:config, %Config{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Configs")
    |> assign(:config, nil)
  end

  @impl true
  def handle_info({AsicSentryWeb.ConfigLive.FormComponent, {:saved, config}}, socket) do
    {:noreply, stream_insert(socket, :configs, config)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    config = Configs.get_config!(id)
    {:ok, _} = Configs.delete_config(config)

    {:noreply, stream_delete(socket, :configs, config)}
  end
end
