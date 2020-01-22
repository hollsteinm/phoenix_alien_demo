defmodule AlienDemoWeb.FormateDateTime do
  @moduledoc """
  A module that provides a simple date format
  """
  def format(%DateTime{ year: year, day: day, month: month, hour: hour, minute: minute, zone_abbr: timezone }) do
    "#{year}/#{month}/#{day} @ #{hour}:#{String.pad_leading(Integer.to_string(minute), 1, "0")} #{timezone}"
  end
end
