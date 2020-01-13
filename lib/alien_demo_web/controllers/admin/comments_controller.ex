defmodule AlienDemoWeb.Admin.CommentsController do
  use AlienDemoWeb.Admin, :controller

  plug :fetch_comments
  plug :flash_comments_workload

  def index(conn, _params) do
    render(conn, "index.html")
  end

  defp fetch_comments(conn, _) do
    assign(conn, :comments, [])
  end

  defp flash_comments_workload(conn, _) do
    if length(conn.assigns[:comments]) == 0 do
      conn |> put_flash(:info, "Congratulations, you have no work to do. Go find some aliens!")
    else
      conn
    end
  end
end
