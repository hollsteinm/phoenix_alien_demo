defmodule AlienDemoWeb.PageController do
  use AlienDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
