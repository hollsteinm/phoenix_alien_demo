defmodule AlienDemoWeb.Plugs.AnonymousAuth do
  @moduledoc """
  Enable anonymous authorization within your application
  """
  import Plug.Conn

  @saltines "e5fg"

  defp create_anonymous(conn, name_prefix) do
    user_id = "#{name_prefix}_#{:rand.uniform(1_000_000_000)}"
    token =
      Phoenix.Token.sign(
        AlienDemoWeb.Endpoint,
        @saltines,
        user_id
      )
    conn
    |> put_session(:user_token, token)
    |> assign(:user_token, token)
    |> assign(:user_id, user_id)
  end

  defp refresh_token(conn, user_id) do
    token = Phoenix.Token.sign(AlienDemoWeb.Endpoint, @saltines, user_id)

    conn
    |> put_session(:user_token, token)
    |> assign(:user_token, token)
    |> assign(:user_id, user_id)
  end

  def init(name_prefix), do: name_prefix

  def call(conn, name_prefix) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(AlienDemoWeb.Endpoint, @saltines, get_session(conn, :user_token),
             max_age: 86400
           ) do
      refresh_token(conn, user_id)
    else
      {:error, :expired} ->
        with {:ok, user_id} <-
               Phoenix.Token.verify(AlienDemoWeb.Endpoint, @saltines, get_session(conn, :user_token)) do
          refresh_token(conn, user_id)
        else
          _ ->
            create_anonymous(conn, name_prefix)
        end

      _ ->
        create_anonymous(conn, name_prefix)
    end
  end
end
