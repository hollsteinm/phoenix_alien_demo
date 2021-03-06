defmodule AlienDemoWeb.AliensController do
  use AlienDemoWeb, :controller

  def index(conn, _params) do
    # we could also do :index (an atom); however, it will
    # postfix a filetype based on the content type
    # of the Accepts header. This would work for serving
    # a page and page data with different Accepts headers.
    render(conn, "index.html")
  end

  def is_alien(conn, %{"name" => alien_name}) do
    render(conn, :is_alien, name: alien_name)
  end
end
