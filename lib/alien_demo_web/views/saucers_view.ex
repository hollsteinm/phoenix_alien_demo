defmodule AlienDemoWeb.SaucersView do
  use AlienDemoWeb, :view

  def render("index.json", %{ saucers: saucers }) do
    render_many(saucers, AlienDemoWeb.SaucersView, "show.json", as: :saucer )
  end

  def render("show.json", %{ saucer: saucer }) do
    %{
      :saucer_id => saucer.id,
      :saucer_name => saucer.name,
      :saucer_description => saucer.description
    }
  end

  def format_comment_link_text(%{comment_ids: comments}) when comments == [] do
    "No Comments"
  end

  def format_comment_link_text(%{comment_ids: comments}) do
    "View #{length(comments)} Comments"
  end
end
