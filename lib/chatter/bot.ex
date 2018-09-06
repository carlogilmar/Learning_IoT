defmodule Chatter.Bot do
  @bot :simple_bot
  def bot(), do: @bot

  use ExGram.Bot, name: @bot
  require Logger

  command("echo")
  middleware(ExGram.Middleware.IgnoreUsername)

	def handle({:text, text, msg}, cnt) do
		IO.puts "Bot respondiendo..."
		IO.inspect text
		IO.inspect msg
		cnt |> answer(" Bot de Elixir desde Raspberrypi Respondiendo")
	end

  def handle({:command, :echo, %{text: t}}, cnt) do
    cnt |> answer(t)
  end

end
