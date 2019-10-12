defmodule Jarmotion.Service.AlertPostService do
  alias Jarmotion.Schemas.Alert

  def post_add_alert(%Alert{} = _) do
    {:error, :not_implemented}
  end
end
