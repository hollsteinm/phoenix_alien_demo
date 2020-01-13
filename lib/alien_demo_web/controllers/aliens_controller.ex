defmodule AlienDemoWeb.AliensController do
  use AlienDemoWeb, :controller

  def index(conn, _params) do
    # we could also do :index (an atom); however, it will
    # postfix a filetype based on the content type
    # of the Accepts header. This would work for serving
    # a page and page data with different Accepts headers.
    render(conn, "index.html")
  end

  # we can take the params input and use pattern matching on
  # the atom defined in the route (which internal is passed to
  # a Map module function to create a map) to set "variables"
  def is_alien(conn, %{"name" => alien_name}) do
    render(conn, "is_alien.html", name: alien_name)
  end
end
