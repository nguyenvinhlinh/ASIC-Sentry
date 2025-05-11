defmodule AsicSentryWeb.ConfigLive.Index do
  use AsicSentryWeb, :live_view_container_grow

  alias AsicSentry.Configs
  alias AsicSentry.Configs.Config

  embed_templates "index_html/*"

  @impl true
  def mount(_params, _session, socket) do
    config_list = Configs.list_configs()
    socket_mod = socket
    |> assign(:page_title, "Config Index")
    |> stream(:config_list, config_list)
    {:ok, socket_mod}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    config = Configs.get_config!(id)
    {:ok, _} = Configs.delete_config(config)
    {:noreply, stream_delete(socket, :configs, config)}
  end
end
