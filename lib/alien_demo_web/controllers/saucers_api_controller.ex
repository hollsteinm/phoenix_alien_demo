defmodule AlienDemoWeb.SaucersAPIController do
  use AlienDemoWeb, :controller

  def get(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> put_resp_header("x-owner", "illuminati")
    |> send_resp(404, "There are no saucers")
  end
end
