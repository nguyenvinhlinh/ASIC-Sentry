defmodule AsicSentryWeb.RealtimeLog.Index do
  use AsicSentryWeb, :live_view

  embed_templates "index_html/*"

  @impl true
  def mount(_params, _session, socket) do
    log_list = []
    if connected?(socket) do
      Phoenix.PubSub.subscribe(AsicSentry.PubSub, "realtime_log_channel")
    end

    socket_mod = stream(socket, :log_list, log_list, [at: 0,limit: 100])

    {:ok, socket_mod}
  end

  def handle_info({:realtime_log_channel, :new, log}, socket) do
    socket_mod =
      socket
      |> stream_insert(:log_list, log, [at: 0,limit: 100])
    {:noreply, socket_mod}
  end
end
