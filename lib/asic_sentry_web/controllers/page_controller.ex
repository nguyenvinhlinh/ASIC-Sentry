defmodule AsicSentryWeb.PageController do
  use AsicSentryWeb, :controller

  def home(conn, _params) do
    conn
    |> redirect(to: "/asic_miners")
  end
end
