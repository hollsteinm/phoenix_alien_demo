defmodule AlienDemoWeb.Admin do
  @moduledoc """
  The AlienDemoWeb.Admin module is a submodule helper for
  AlienDemoWeb "admin" scoped controllers and views. This
  simply makes the use statements in admin controllers and
  views to import AlienDemoWeb.Admin scoped modules and
  aliasing.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: AlienDemoWeb.Admin

      import Plug.Conn
      import AlienDemoWeb.Gettext
      alias AlienDemoWeb.Router.Helpers, as: Routes #use the route helpers provided by the root application
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/alien_demo_web/templates/admin",
        namespace: AlienDemoWeb.Admin

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import AlienDemoWeb.ErrorHelpers
      import AlienDemoWeb.Gettext
      alias AlienDemoWeb.Router.Helpers, as: Routes #use the route helpers provided by the root application
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
