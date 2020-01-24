defmodule AlienDemoWeb.SaucersController do
  use AlienDemoWeb, :controller
  alias AlienDemo.{Repo, Saucer}

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
      ],
      :reported_datetime => DateTime.utc_now()
    },
    %{
      :id => 1,
      :name => "rectangle",
      :description =>
        "commonly mistaken as a stealth bomber, the rectangle is an intimidating saucer",
      :comment_ids => [],
      :reported_datetime => DateTime.utc_now()
    }
  ]

  def index(conn, _params) do
    render(conn, :index,
      saucers:
        Enum.map(
          Repo.all(Saucer),
          fn %Saucer{title: name, content: description, submission_datetime: reported_datetime, id: id} ->
            %{
              :name => name,
              :description => description,
              :reported_datetime => reported_datetime,
              :id => id,
              :comment_ids => []
            }
          end
        )
    )
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

  def create(conn, %{"name" => title, "description" => content}) do
    with {:ok, _struct} <-
           Repo.insert(%Saucer{
             title: title,
             content: content,
             submission_datetime: DateTime.truncate(DateTime.utc_now(), :second)
           }) do
      conn
      |> put_flash(:info, gettext("Saucer Submitted."))
      |> redirect(to: Routes.saucers_path(conn, :index))
    else
      {:error, changeset} ->
        error_string =
          Map.values(changeset.errors)
          |> Enum.map(fn {error, _} -> error end)
          |> Enum.join(", ")

        conn
        |> put_flash(:error, error_string)
        |> redirect(to: Routes.saucers_path(conn, :index))
    end
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
