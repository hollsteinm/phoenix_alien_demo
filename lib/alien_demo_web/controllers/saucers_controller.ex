defmodule AlienDemoWeb.SaucersController do
  use AlienDemoWeb, :controller
  alias AlienDemo.{Repo, Saucer}

  action_fallback AlienDemoWeb.ControllerErrorFallback

  def index(conn, _params) do
    render(conn, :index,
      saucers:
        Enum.map(
          Repo.all(Saucer),
          fn %Saucer{
               title: name,
               content: description,
               submission_datetime: reported_datetime,
               id: id
             } ->
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

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, %{"id" => saucer_id}) do
    with {:ok,
          %Saucer{
            title: name,
            content: description,
            submission_datetime: reported_datetime,
            id: id
          }} <- fetch_saucers(saucer_id) do
      conn
      |> render(:show,
        saucer: %{
          :name => name,
          :description => description,
          :reported_datetime => reported_datetime,
          :id => id,
          :comment_ids => []
        }
      )
    end
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

  defp fetch_saucers(id) do
    with {saucer_id, _text} <- Integer.parse(id), saucer <- Repo.get(Saucer, saucer_id) do
      {:ok, saucer}
    else
      nil ->
        {:error, :not_found}

      :error ->
        {:error, :bad_request}
    end
  end
end
