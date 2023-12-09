defmodule ContactApp.Repo do
  use Ecto.Repo,
    otp_app: :contact_app,
    adapter: Ecto.Adapters.Postgres
end
