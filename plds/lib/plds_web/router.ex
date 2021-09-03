defmodule PLDSWeb.Router do
  use PLDSWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PLDSWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]

    live_dashboard "/",
      metrics: PLDSWeb.Telemetry,
      additional_pages: [broadway: BroadwayDashboard]
  end
end
