defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  @conn ParzivalWeb.Endpoint

  def pages do
    base_pages()
  end

  defp base_pages do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.landing_home_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :missions,
        title: "Missions",
        url: Routes.landing_missions_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :faqs,
        title: "Faqs",
        url: Routes.landing_faqs_index_path(@conn, :index),
        tabs: []
      }
    ]
  end
end
