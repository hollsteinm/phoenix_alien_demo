defmodule AlienDemoWeb.UserSocket do
  use Phoenix.Socket

  channel "users:*", AlienDemoWeb.UserChannel
  channel "room:*", AlienDemoWeb.ChatRoomChannel
  channel "private:*", AlienDemoWeb.ChatPrivateChannel

  def connect(%{"user_token" => user_token}, socket, _connect_info) do
    with {:ok, user_id} <- login(user_token) do
      assign(socket, :user_id, user_id)

      {:ok, socket}
    else
      {:error, :unauthenticated} -> :error
      {:error, _} -> :error
    end
  end

  def id(socket), do: "user_socket:user:#{socket.assigns[:user_id]}"

  defp login(nil) do
    {:error, :unauthenticated}
  end

  defp login(user_token) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(AlienDemoWeb.Endpoint, "e5fg", user_token, max_age: 86400) do
      {:ok, user_id}
    else
      error -> error
    end
  end
end
