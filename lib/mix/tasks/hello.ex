defmodule Mix.Tasks.Hello do
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    # calling our Hello.say() function from earlier
    IO.puts("hello")
  end
end
