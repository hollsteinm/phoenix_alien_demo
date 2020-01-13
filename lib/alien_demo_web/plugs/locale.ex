defmodule AlienDemoWeb.Plugs.Locale do
  @moduledoc """
  Assigne a locale to the application if present in the query parameter "locale"
  The default and fallback of an invalid local is "en". By default supports
  "en" (English) and "de" (Deutsch). Note, this is not configured for LCID locale
  """
  import Plug.Conn

  @locales ["en", "de"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    assign(conn, :locale, loc)
  end

  def call(conn, default), do: assign(conn, :locale, default)
end
