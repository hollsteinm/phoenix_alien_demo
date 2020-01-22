defmodule AlienDemoWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", AlienDemoWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"username" => username, "password" => password}, socket, _connect_info) do
    with {:ok, user_id} <- login(username, password) do
      socket
      |> assign(:user_id, user_id)
      |> assign(
        :user_token,
        Phoenix.Token.sign(AlienDemoWeb.Endpoint, "e5fg", user_id)
      )

      {:ok, socket}
    else
      {:error, :unauthenticated} -> :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     AlienDemoWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "user_socket:user:#{socket.assigns.user_id}"

  defp login(nil, nil) do
    {:error, :unauthenticated}
  end

  defp login(_username, _password) do
    {:ok, 0}
  end
end
