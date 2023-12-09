defmodule ContactAppWeb.PageController do
  use ContactAppWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: "/contacts")
  end
end
