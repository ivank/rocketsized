defmodule RocketsizedWeb.Router do
  use RocketsizedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RocketsizedWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :put_layout, html: {RocketsizedWeb.Layouts, :admin}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RocketsizedWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/rocketgrid", RocketgridLive.Index, :index

    live "/vehicles", VehicleLive.Index, :index
    live "/vehicles/new", VehicleLive.Index, :new
    live "/vehicles/:id/edit", VehicleLive.Index, :edit

    live "/vehicles/:id", VehicleLive.Show, :show
    live "/vehicles/:id/show/edit", VehicleLive.Show, :edit
  end

  scope "/admin", RocketsizedWeb.Admin do
    pipe_through [:browser, :admin]

    resources "/rockets", RocketController
    resources "/countries", CountryController
    resources "/orgs", OrgController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RocketsizedWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rocketsized, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RocketsizedWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
