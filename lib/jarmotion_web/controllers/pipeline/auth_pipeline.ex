defmodule JarmotionWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :jarmotion,
    module: Jarmotion.Guardian,
    error_handler: JarmotionWeb.ErrorController

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
