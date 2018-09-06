defmodule Chatter.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(ExGram, []),
      supervisor(ChatterWeb.Endpoint, []),
      supervisor(Chatter.Bot, [:polling, ExGram.Config.get(:ex_gram, :token) ]),
      supervisor(Chatter.Uart, []),
			supervisor(Chatter.Director, [])
    ]

    opts = [strategy: :one_for_one, name: Chatter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ChatterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
