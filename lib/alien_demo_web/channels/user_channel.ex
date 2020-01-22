defmodule AlienDemoWeb.UserChannel do
  use Phoenix.Channel

  def join("users:join", _params, socket) do
      {:ok, "Hello", socket}
  end
end
