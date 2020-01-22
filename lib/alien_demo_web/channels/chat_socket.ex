defmodule AlienDemoWeb.ChatSocket do
  use Phoenix.Socket

  channel "room:*", AlienDemoWeb.ChatRoomChannel
  channel "private:*", AlienDemoWeb.ChatPrivateChannel

  def connect(%{"user_token" => user_token}, socket, _connect_info) do
    with {:ok, user_id} <- verify_connect(user_token) do
      socket
      |> assign(:user_id, user_id)
      |> assign(:connection_datetime, DateTime.utc_now())

      {:ok, socket}
    else
      {:error, :unauthorized} -> :error
    end
  end

  def id(socket), do: "chat_socket:user:#{socket.assigns.user_id}"

  defp verify_connect(nil) do
    {:error, :unauthorized}
  end

  defp verify_connect(user_token) do
    Phoenix.Token.verify(AlienDemoWeb.Endpoint, "567f", user_token, max_age: 86400)
  end
end
