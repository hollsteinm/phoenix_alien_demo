defmodule AlienDemoWeb.ChatPrivateChannel do
  def join("private:" <> _group_id, _params, _socket) do
    { :error, %{reason: "group does not exsist"} }
  end
end
