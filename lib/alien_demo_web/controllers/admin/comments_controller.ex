defmodule AlienDemoWeb.Admin.CommentsController do
  use AlienDemoWeb.Admin, :controller

  plug :fetch_comments
  plug :flash_comments_workload
  plug :flash_HAL when action in [:show]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def update(conn, %{ "id" => comment_id }) do
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

  # remember, pattern matching order of operations is top down
  defp fetch_comments(conn, "123") do
    assign(conn, :comment, %{
      :title => "this is the title of the comment",
      :content => "this is the content of the comment"
    })
  end

  defp fetch_comments(conn, "124") do
    assign(conn, :comment, %{
      :title => "this is the title of another comment",
      :content => "this is the content of another comment"
    })
  end

  defp fetch_comments(conn, "125") do
    assign(conn, :comment, %{
      :title => "Lights over Lake Michigan",
      :content => "I saw lights over Lake Michigan. Totally not a plane because they were spinning!"
    })
  end

  defp fetch_comments(conn, {:status, "pending_review"}) do
    assign(conn, :comments, [
      %{
        :id => 123,
        :title => "this is the title of the comment",
        :content => "this is the content of the comment"
      },
      %{
        :id => 124,
        :title => "this is the title of another comment",
        :content => "this is the content of another comment"
      }
    ])
  end

  defp fetch_comments(%Plug.Conn{
    :params => %{ "id" => comment_id }
  } = conn, _) do
    fetch_comments(conn, comment_id)
  end

  defp fetch_comments(%Plug.Conn{
    :query_params => %{ "status" => status_query }
  } = conn, _) do
    fetch_comments(conn, { :status, status_query })
  end

  defp fetch_comments(conn, opts) when not is_bitstring(opts) do
    assign(conn, :comments, [
      %{
        :id => 123,
        :title => "this is the title of the comment",
        :content => "this is the content of the comment",
        :status => "pending_review"
      },
      %{
        :id => 124,
        :title => "this is the title of another comment",
        :content => "this is the content of another comment",
        :status => "pending_review"
      },
      %{
        :id => 125,
        :title => "Lights over Lake Michigan",
        :content => "I saw lights over Lake Michigan. Totally not a plane because they were spinning!",
        :status => "admin_approved"
      }
    ])
  end

  defp fetch_comments(conn, invalid_comment_id) when is_bitstring(invalid_comment_id) and invalid_comment_id not in ["123", "124", "125"] do
    text(conn, "#{invalid_comment_id} is not a valid id.")
  end

  defp flash_comments_workload(%Plug.Conn{
    assigns: %{
      :comments => comments
    }
  } = conn, _) do
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
