defmodule AlienDemoWeb.Admin.CommentsController do
  use AlienDemoWeb.Admin, :controller

  plug :fetch_comments when action in [:index]
  plug :flash_comments_workload
  plug :flash_HAL when action in [:show]

  action_fallback AlienDemoWeb.ControllerErrorFallback

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def edit(conn, %{"id" => comment_id }) do
    with {:ok, comment} <- fake_fetch(comment_id) do
      conn
      |> put_flash(:info, "Your name will be added to the changes")
      |> put_layout("app-edit.html")
      |> render("edit.html", comment: comment)
    end
  end

  def show(conn, %{"id" => comment_id}) do
    with {:ok, comment} <- fake_fetch(comment_id) do
      render(conn, "show.html", comment: comment)
    end
  end

  def update(conn, %{"id" => comment_id}) do
    conn
    |> put_flash(:info, "In a real world, I would have updated comment ##{comment_id}.")
    |> redirect(to: Routes.admin_comments_path(conn, :show, comment_id))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:error, "I'm sorry Dave, I can't do that.")
    |> redirect(to: Routes.admin_comments_path(conn, :index))
  end

  defp flash_HAL(conn, _) do
    put_flash(conn, :info, "Hello Admin")
  end

  defp fake_fetch("123") do
    {:ok,
     %{
       :id => 123,
       :title => "this is the title of the comment",
       :content => "this is the content of the comment",
       :submission_time => DateTime.utc_now
     }}
  end

  defp fake_fetch("124") do
    {:ok,
     %{
       :id => 124,
       :title => "this is the title of another comment",
       :content => "this is the content of another comment",
       :submission_time => DateTime.utc_now
     }}
  end

  defp fake_fetch("125") do
    {:ok,
     %{
       :id => 125,
       :title => "Lights over Lake Michigan",
       :content =>
         "I saw lights over Lake Michigan. Totally not a plane because they were spinning!",
         :submission_time => DateTime.utc_now
     }}
  end

  defp fake_fetch(_id) do
    {:error, :not_found}
  end

  defp fetch_comments(
         %Plug.Conn{
           :query_params => %{"status" => "pending_review"}
         } = conn,
         _
       ) do
    assign(conn, :comments, [
      %{
        :id => 123,
        :title => "this is the title of the comment",
        :content => "this is the content of the comment",
        :submission_time => DateTime.utc_now
      },
      %{
        :id => 124,
        :title => "this is the title of another comment",
        :content => "this is the content of another comment",
        :submission_time => DateTime.utc_now
      }
    ])
  end

  defp fetch_comments(
         %Plug.Conn{
           :params => %{"id" => comment_id}
         } = conn,
         _
       ) do
    with {:ok, comment} <- fake_fetch(comment_id) do
      assign(conn, :comment, comment)
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.html")
        |> halt()
    end
  end

  defp fetch_comments(conn, _opts) do
    assign(conn, :comments, [
      %{
        :id => 123,
        :title => "this is the title of the comment",
        :content => "this is the content of the comment",
        :status => "pending_review",
        :submission_time => DateTime.utc_now
      },
      %{
        :id => 124,
        :title => "this is the title of another comment",
        :content => "this is the content of another comment",
        :status => "pending_review",
        :submission_time => DateTime.utc_now
      },
      %{
        :id => 125,
        :title => "Lights over Lake Michigan",
        :content =>
          "I saw lights over Lake Michigan. Totally not a plane because they were spinning!",
        :status => "admin_approved",
        :submission_time => DateTime.utc_now
      }
    ])
  end

  defp flash_comments_workload(
         %Plug.Conn{
           assigns: %{
             :comments => comments
           }
         } = conn,
         _
       ) do
    if length(comments) == 0 do
      conn |> put_flash(:info, "Congratulations, you have no work to do. Go find some aliens!")
    else
      conn |> put_flash(:info, "There are #{length(comments)} items for review.")
    end
  end

  defp flash_comments_workload(conn, _) do
    conn
  end
end
