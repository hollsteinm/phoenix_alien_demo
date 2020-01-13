defmodule AlienDemoWeb.Admin.CommentsController do
  use AlienDemoWeb.Admin, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
