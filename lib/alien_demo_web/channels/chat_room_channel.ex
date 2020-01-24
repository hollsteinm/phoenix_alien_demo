defmodule AlienDemoWeb.ChatRoomChannel do
  use Phoenix.Channel
  alias AlienDemoWeb.Presence

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _room_name, _params, _socket) do
    {:error, %{reason: "room does not exsist"}}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "user:entered", %{user_id: socket.assigns.user_id})
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })
    {:noreply, socket}
  end

  def handle_in("message:new", %{"content" => content}, socket) do
    broadcast!(socket, "message:new", %{user_id: socket.assigns.user_id, content: content})
    {:reply, {:ok, %{content: content}}, assign(socket, :user_id, socket.assigns.user_id)}
  end
end
