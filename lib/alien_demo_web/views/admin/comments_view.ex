defmodule AlienDemoWeb.Admin.CommentsView do
  use AlienDemoWeb.Admin, :view

  def render("index.html", %{comments: comments, conn: conn}) do
    render_many(comments, AlienDemoWeb.Admin.CommentsView, "show.html", %{ as: :comment, conn: conn } )
  end

  def submission_date(%{submission_time: submission_time}) do
    "submitted on #{format(submission_time)}"
  end
end
