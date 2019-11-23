defmodule Mix.Tasks.GenerateCode do
  use Mix.Task
  alias Jarmotion.Application
  alias Jarmotion.Service.RegistrationService

  def run(_) do
    Mix.Task.run("app.start")
    {:ok, file} = File.open("generated_code.csv", [:append])

    Enum.each(0..20, fn _ ->
      {:ok, code} = RegistrationService.generate()
      IO.binwrite(file, code.code <> "\n")
    end)

    File.close(file)
  end
end
