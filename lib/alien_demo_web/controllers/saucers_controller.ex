defmodule AlienDemoWeb.SaucersController do
  use AlienDemoWeb, :controller

  action_fallback AlienDemoWeb.ControllerErrorFallback

  @saucers [
    %{
      :id => 0,
      :name => "disc",
      :description => "classic saucer with anti gravity engines.",
      :comment_ids => [
        123,
        124,
        125
      ]
    },
    %{
      :id => 1,
      :name => "rectangle",
      :description =>
        "commonly mistaken as a stealth bomber, the rectangle is an intimidating saucer",
      :comment_ids => []
    }
  ]

  def index(conn, _params) do
    with {:ok, saucers} <- fetch_saucers() do
      conn
      |> render(:index, saucers: saucers)
    end
  end

  def show(conn, %{"id" => saucer_id}) do
    with {:ok, saucer} <- fetch_saucers(saucer_id) do
      conn
      |> render(:show, saucer: saucer)
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, gettext("Still can't create"))
    |> redirect(to: Routes.saucers_path(conn, :index))
  end

  defp fetch_saucers() do
    {:ok, @saucers}
  end

  defp fetch_saucers(id) do
    with [saucer | _tail] <-
           Enum.filter(@saucers, fn %{:id => saucer_id} -> "#{saucer_id}" == id end) do
      {:ok, saucer}
    else
      [] -> {:error, :not_found}
    end
  end
end
