defmodule AlienDemoWeb.ChatRoomChannel do
  use Phoenix.Channel

  def join("room:lobby", message, socket) do
    send(self(), {:after_join, message})
    {:ok, socket}
  end

  def join("room:" <> _room_name, _params, _socket) do
    {:error, %{reason: "room does not exsist"}}
  end

  def handle_info({:after_join, message}, socket) do
    broadcast!(socket, "user:entered", %{user_id: message["user_id"]})
    push(socket, "join", %{status: "connected"})
    {:noreply, socket}
  end

  def handle_in("message:new", %{"content" => content, "user_id" => user_id}, socket) do
    broadcast!(socket, "message:new", %{user_id: user_id, content: content})
    {:reply, {:ok, %{content: content}}, assign(socket, :user_id, user_id)}
  end
end
