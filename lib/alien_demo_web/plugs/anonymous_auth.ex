defmodule AlienDemoWeb.Plugs.AnonymousAuth do
  @moduledoc """
  Enable anonymous authorization within your application
  """
  import Plug.Conn

  def init(name_prefix), do: name_prefix

  def call(conn, name_prefix) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(AlienDemoWeb.Endpoint, "e5fg", get_session(conn, :user_token),
             max_age: 86400
           ) do
      token = Phoenix.Token.sign(AlienDemoWeb.Endpoint, "e5fg", user_id)

      conn
      |> put_session(:user_token, token)
      |> assign(:user_token, token)
    else
      {:error, :expired} ->
        with {:ok, user_id} <-
               Phoenix.Token.verify(AlienDemoWeb.Endpoint, "e5fg", get_session(conn, :user_token)) do
          token = Phoenix.Token.sign(AlienDemoWeb.Endpoint, "e5fg", user_id)

          conn
          |> put_session(:user_token, token)
          |> assign(:user_token, token)
        else
          _ ->
            token =
              Phoenix.Token.sign(
                AlienDemoWeb.Endpoint,
                "e5fg",
                "#{name_prefix}_#{:rand.uniform(1_000_000_000)}"
              )

            conn
            |> put_session(:user_token, token)
            |> assign(:user_token, token)
        end

      _ ->
        token =
          Phoenix.Token.sign(
            AlienDemoWeb.Endpoint,
            "e5fg",
            "#{name_prefix}_#{:rand.uniform(1_000_000_000)}"
          )

        conn
        |> put_session(:user_token, token)
        |> assign(:user_token, token)
    end
  end
end
