defmodule JarmotionWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias JarmotionWeb.Router.Helpers, as: Routes
      alias Jarmotion.Guardian
      alias Jarmotion.Schemas.User

      # The default endpoint for testing
      @endpoint JarmotionWeb.Endpoint

      def authenticate(conn, %User{} = user) do
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{role: :admin})

        put_req_header(conn, "authorization", "Bearer #{jwt}")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Jarmotion.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Jarmotion.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
