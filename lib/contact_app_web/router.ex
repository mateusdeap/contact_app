defmodule ContactAppWeb.Router do
  use ContactAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ContactAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContactAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/contacts", ContactController, :index
    delete "/contacts", ContactController, :delete_all
    get "/contacts/new", ContactController, :new
    post "/contacts/new", ContactController, :create
    get "/contacts/email", ContactController, :email
    get "/contacts/count", ContactController, :count
    get "/contacts/:id", ContactController, :show
    get "/contacts/:id/edit", ContactController, :edit
    post "/contacts/:id/edit", ContactController, :update
    delete "/contacts/:id", ContactController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContactAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:contact_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ContactAppWeb.Telemetry
    end
  end
end
