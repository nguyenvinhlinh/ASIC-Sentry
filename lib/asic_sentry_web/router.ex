defmodule AsicSentryWeb.Router do
  use AsicSentryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AsicSentryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_nexus do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AsicSentryWeb.Layouts, :nexus_root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AsicSentryWeb do
    pipe_through :browser_nexus

    live "/asic_miners",          AsicMinerLive.Index, :index
    live "/asic_miners/new",      AsicMinerLive.New,   :new
    live "/asic_miners/:id/edit", AsicMinerLive.Edit,  :edit

    live "/configs",     ConfigLive.Index, :index
    live "/configs/new", ConfigLive.New,   :new
    #live "/configs/new", ConfigLive.Index, :new
    #live "/configs/:id/edit", ConfigLive.Index, :edit
    #live "/configs/:id", ConfigLive.Show, :show
    #live "/configs/:id/show/edit", ConfigLive.Show, :edit
  end
  scope "/", AsicSentryWeb do
    pipe_through :browser

    get "/", PageController, :home

    # live "/asic_miners", AsicMinerLive.Index, :index
    # live "/asic_miners/new", AsicMinerLive.Index, :new
    # live "/asic_miners/:id/edit", AsicMinerLive.Index, :edit


    # live "/configs", ConfigLive.Index, :index
    # live "/configs/new", ConfigLive.Index, :new
    # live "/configs/:id/edit", ConfigLive.Index, :edit
    # live "/configs/:id", ConfigLive.Show, :show
    # live "/configs/:id/show/edit", ConfigLive.Show, :edit

    live "/realtime_logs", RealtimeLog.Index, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", AsicSentryWeb do
  #   pipe_through :api
  # end



  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:asic_sentry, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AsicSentryWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
