defmodule ParzivalWeb.Router do
  use ParzivalWeb, :router

  import ParzivalWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ParzivalWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParzivalWeb do
    pipe_through [:browser]

    live_session :user, on_mount: [{ParzivalWeb.Hooks, :current_user}] do
      scope "/", Landing, as: :landing do
        live "/", HomeLive.Index, :index

        live "/schedule", ScheduleLive.Index, :index
        live "/missions", MissionsLive.Index, :index
        live "/speakers", SpeakersLive.Index, :index
        live "/faqs", FaqsLive.Index, :index
        live "/team", TeamLive.Index, :index
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ParzivalWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ParzivalWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
