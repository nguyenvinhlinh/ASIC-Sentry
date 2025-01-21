defmodule AsicSentry.RealtimeLogs do

  def broadcast(level, message) do
    timestamp = NaiveDateTime.utc_now()

    log = %{
      id: timestamp,
      timestamp: timestamp,
      level: level,
      message: message
    }
    Phoenix.PubSub.broadcast(AsicSentry.PubSub, "realtime_log_channel",
      {:realtime_log_channel , :new, log})
  end
end
