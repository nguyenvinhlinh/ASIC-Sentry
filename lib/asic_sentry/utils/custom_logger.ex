defmodule AsicSentry.Utils.CustomLogger do
  require Logger
  alias AsicSentry.RealtimeLogs

  def log_and_broadcast(:error, message) do
    Logger.error(message)
    RealtimeLogs.broadcast("ERROR", message)
  end

  def log_and_broadcast(:info, message) do
    Logger.info(message)
    RealtimeLogs.broadcast("INFO", message)
  end
end
