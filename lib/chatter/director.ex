defmodule Chatter.Director do

  use GenServer

  @songs [ "song1", "song2", "song3"  ]

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def get_current() do
    GenServer.call( __MODULE__, :get_song )
  end

  def suscribe() do
    GenServer.call( __MODULE__, :suscribe)
  end

  def init(_) do
    {:ok, {:counter, 0} }
  end

  def handle_call( :get_song, _, state) do
    {:reply, state, state}
  end

  def handle_call( :suscribe, _, state ) do
    {_, counter} = state
    {:reply, counter+1, state}
  end

end
