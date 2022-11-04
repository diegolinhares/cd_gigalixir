defmodule CdGigalixirWeb.Router do
  use CdGigalixirWeb, :router

  import CdGigalixirWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CdGigalixirWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", CdGigalixirWeb do
    pipe_through :browser

    live_session :create_cart_session, on_mount: CdGigalixirWeb.LiveSessions.Cart do
      live "/", MainLive, :index
      live "/cart", CartLive, :index
    end
  end

  # coveralls-ignore-start

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CdGigalixirWeb.Telemetry
    end
  end

  # coveralls-ignore-stop

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CdGigalixirWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", CdGigalixirWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live_session :is_admin, on_mount: {CdGigalixirWeb.LiveSessions.Permissions, :admin} do
      scope "/admin", Admin, as: :admin do
        live "/products", ProductLive, :index
        live "/products/new", ProductLive, :new
        live "/products/:id/edit", ProductLive, :edit
        live "/products/:id", ProductLive.Show, :show
      end
    end
  end

  scope "/", CdGigalixirWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
