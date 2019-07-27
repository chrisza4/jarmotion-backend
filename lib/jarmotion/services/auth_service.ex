defmodule Jarmotion.Service.AuthService do
  def login_for_user(_email, _password) do
    {:error, :unauthorized}
  end
end
