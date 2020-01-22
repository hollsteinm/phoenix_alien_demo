defmodule AlienDemoWeb.ChatRoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    { :ok, socket }
  end

  def join("room:" <> _room_name, _params, _socket) do
    { :error, %{reason: "room does not exsist"} }
  end
end
